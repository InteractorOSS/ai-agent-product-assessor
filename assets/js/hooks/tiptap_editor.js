/**
 * TipTap Editor LiveView Hook
 *
 * Integrates TipTap rich text editor with Phoenix LiveView.
 * Handles content synchronization between the editor and LiveView state.
 */

// TipTap imports - these need to be installed via npm
// npm install @tiptap/core @tiptap/starter-kit @tiptap/extension-placeholder --prefix assets

let Editor, StarterKit, Placeholder;

// Dynamically import TipTap to handle cases where it's not installed
const loadTipTap = async () => {
  try {
    const [core, starterKit, placeholder] = await Promise.all([
      import('@tiptap/core'),
      import('@tiptap/starter-kit'),
      import('@tiptap/extension-placeholder')
    ]);
    Editor = core.Editor;
    StarterKit = starterKit.default || starterKit.StarterKit;
    Placeholder = placeholder.default || placeholder.Placeholder;
    return true;
  } catch (e) {
    console.warn('TipTap not installed. Using fallback textarea editor.');
    return false;
  }
};

const TipTapEditor = {
  editor: null,
  debounceTimer: null,

  async mounted() {
    const hasTipTap = await loadTipTap();

    if (hasTipTap) {
      this.initTipTap();
    } else {
      this.initFallback();
    }
  },

  initTipTap() {
    const content = this.el.dataset.content || '';
    const section = this.el.dataset.section;

    // Create editor container
    const editorElement = document.createElement('div');
    editorElement.className = 'tiptap-content';
    this.el.appendChild(editorElement);

    // Create toolbar
    const toolbar = this.createToolbar();
    this.el.insertBefore(toolbar, editorElement);

    // Initialize TipTap
    this.editor = new Editor({
      element: editorElement,
      extensions: [
        StarterKit.configure({
          heading: {
            levels: [2, 3, 4]
          }
        }),
        Placeholder.configure({
          placeholder: 'Start typing...'
        })
      ],
      content: this.markdownToHtml(content),
      onUpdate: ({ editor }) => {
        this.handleContentChange(editor, section);
      }
    });

    // Focus the editor
    this.editor.commands.focus();
  },

  initFallback() {
    const content = this.el.dataset.content || '';
    const section = this.el.dataset.section;

    // Create a simple textarea as fallback
    const textarea = document.createElement('textarea');
    textarea.className = 'w-full min-h-[400px] p-4 border-0 resize-none focus:outline-none font-mono text-sm';
    textarea.value = content;
    textarea.placeholder = 'Start typing...';

    textarea.addEventListener('input', (e) => {
      this.handleContentChange({ getHTML: () => e.target.value }, section);
    });

    this.el.appendChild(textarea);
    textarea.focus();
  },

  createToolbar() {
    const toolbar = document.createElement('div');
    toolbar.className = 'flex items-center gap-1 p-2 border-b border-gray-200 mb-4';

    const buttons = [
      { label: 'B', command: 'toggleBold', title: 'Bold' },
      { label: 'I', command: 'toggleItalic', title: 'Italic' },
      { label: 'H2', command: () => this.editor.chain().focus().toggleHeading({ level: 2 }).run(), title: 'Heading 2' },
      { label: 'H3', command: () => this.editor.chain().focus().toggleHeading({ level: 3 }).run(), title: 'Heading 3' },
      { label: '•', command: 'toggleBulletList', title: 'Bullet List' },
      { label: '1.', command: 'toggleOrderedList', title: 'Numbered List' },
    ];

    buttons.forEach(btn => {
      const button = document.createElement('button');
      button.type = 'button';
      button.className = 'px-3 py-1 text-sm font-medium text-gray-700 hover:bg-gray-100 rounded';
      button.textContent = btn.label;
      button.title = btn.title;
      button.addEventListener('click', (e) => {
        e.preventDefault();
        if (typeof btn.command === 'function') {
          btn.command();
        } else {
          this.editor.chain().focus()[btn.command]().run();
        }
      });
      toolbar.appendChild(button);
    });

    return toolbar;
  },

  handleContentChange(editor, section) {
    // Debounce the update to avoid too many LiveView messages
    clearTimeout(this.debounceTimer);
    this.debounceTimer = setTimeout(() => {
      const content = this.htmlToMarkdown(editor.getHTML());
      this.pushEvent('content_changed', { content, section });
    }, 500);
  },

  // Simple HTML to Markdown conversion
  htmlToMarkdown(html) {
    return html
      .replace(/<h2[^>]*>(.*?)<\/h2>/gi, '## $1\n\n')
      .replace(/<h3[^>]*>(.*?)<\/h3>/gi, '### $1\n\n')
      .replace(/<h4[^>]*>(.*?)<\/h4>/gi, '#### $1\n\n')
      .replace(/<strong[^>]*>(.*?)<\/strong>/gi, '**$1**')
      .replace(/<b[^>]*>(.*?)<\/b>/gi, '**$1**')
      .replace(/<em[^>]*>(.*?)<\/em>/gi, '*$1*')
      .replace(/<i[^>]*>(.*?)<\/i>/gi, '*$1*')
      .replace(/<li[^>]*>(.*?)<\/li>/gi, '- $1\n')
      .replace(/<ul[^>]*>|<\/ul>/gi, '')
      .replace(/<ol[^>]*>|<\/ol>/gi, '')
      .replace(/<p[^>]*>(.*?)<\/p>/gi, '$1\n\n')
      .replace(/<br\s*\/?>/gi, '\n')
      .replace(/<[^>]+>/g, '')
      .replace(/\n{3,}/g, '\n\n')
      .trim();
  },

  // Simple Markdown to HTML conversion
  markdownToHtml(markdown) {
    return markdown
      .replace(/^#### (.+)$/gm, '<h4>$1</h4>')
      .replace(/^### (.+)$/gm, '<h3>$1</h3>')
      .replace(/^## (.+)$/gm, '<h2>$1</h2>')
      .replace(/\*\*(.+?)\*\*/g, '<strong>$1</strong>')
      .replace(/\*(.+?)\*/g, '<em>$1</em>')
      .replace(/^- (.+)$/gm, '<li>$1</li>')
      .replace(/(<li>.*<\/li>\n?)+/g, '<ul>$&</ul>')
      .replace(/\n\n/g, '</p><p>')
      .replace(/^(.+)$/gm, (match) => {
        if (match.startsWith('<')) return match;
        return `<p>${match}</p>`;
      });
  },

  destroyed() {
    if (this.editor) {
      this.editor.destroy();
    }
    clearTimeout(this.debounceTimer);
  }
};

export default TipTapEditor;
