/**
 * Chat-related LiveView Hooks
 *
 * Provides hooks for the assessment chat interface.
 */

/**
 * ScrollToBottom Hook
 *
 * Automatically scrolls to the bottom of the container when new messages are added.
 */
export const ScrollToBottom = {
  mounted() {
    this.scrollToBottom();
    this.observer = new MutationObserver(() => {
      this.scrollToBottom();
    });
    this.observer.observe(this.el, { childList: true, subtree: true });
  },

  updated() {
    this.scrollToBottom();
  },

  destroyed() {
    if (this.observer) {
      this.observer.disconnect();
    }
  },

  scrollToBottom() {
    this.el.scrollTop = this.el.scrollHeight;
  }
};

/**
 * AutoResizeTextarea Hook
 *
 * Automatically resizes the textarea based on content.
 */
export const AutoResizeTextarea = {
  mounted() {
    this.resize();
    this.el.addEventListener('input', () => this.resize());
  },

  updated() {
    this.resize();
  },

  resize() {
    // Reset height to auto to get the correct scrollHeight
    this.el.style.height = 'auto';

    // Set height to scrollHeight, with min and max constraints
    const minHeight = 48; // 3rem
    const maxHeight = 200; // 12.5rem
    const newHeight = Math.min(Math.max(this.el.scrollHeight, minHeight), maxHeight);

    this.el.style.height = `${newHeight}px`;

    // Add scrollbar if content exceeds max height
    this.el.style.overflowY = this.el.scrollHeight > maxHeight ? 'auto' : 'hidden';
  }
};

/**
 * FocusOnMount Hook
 *
 * Focuses the element when mounted.
 */
export const FocusOnMount = {
  mounted() {
    this.el.focus();
  }
};

export default {
  ScrollToBottom,
  AutoResizeTextarea,
  FocusOnMount
};
