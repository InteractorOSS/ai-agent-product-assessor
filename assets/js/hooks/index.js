/**
 * LiveView Hooks
 *
 * Export all custom hooks for use with Phoenix LiveView.
 */

import TipTapEditor from './tiptap_editor';
import { ScrollToBottom, AutoResizeTextarea, FocusOnMount } from './chat';
import { AutoSaveTextarea } from './autosave';

const Hooks = {
  TipTapEditor,
  ScrollToBottom,
  AutoResizeTextarea,
  FocusOnMount,
  AutoSaveTextarea
};

export default Hooks;
