/**
 * AutoSaveTextarea Hook
 *
 * Provides debounced auto-save functionality for textarea elements.
 * Saves after 800ms of no typing, immediately on blur, and attempts
 * to save on page unload.
 */

export const AutoSaveTextarea = {
  mounted() {
    this.debounceMs = parseInt(this.el.dataset.debounce) || 800;
    this.debounceTimer = null;
    this.lastSavedValue = this.el.value;
    this.isDirty = false;

    // Track input with debounce
    this.el.addEventListener('input', (e) => {
      this.isDirty = e.target.value !== this.lastSavedValue;

      // Clear existing timer
      if (this.debounceTimer) {
        clearTimeout(this.debounceTimer);
      }

      // Set new timer for debounced save
      this.debounceTimer = setTimeout(() => {
        if (this.isDirty) {
          this.save(e.target.value);
        }
      }, this.debounceMs);
    });

    // Immediate save on blur
    this.el.addEventListener('blur', () => {
      if (this.debounceTimer) {
        clearTimeout(this.debounceTimer);
        this.debounceTimer = null;
      }

      if (this.isDirty) {
        this.save(this.el.value);
      }
    });

    // Attempt save on page unload
    this.beforeUnloadHandler = () => {
      if (this.isDirty) {
        // Use synchronous XHR as last resort (beacon API doesn't support complex data)
        // For LiveView, we just trigger the event - it may or may not complete
        this.pushEvent('description_changed', { value: this.el.value });
      }
    };

    window.addEventListener('beforeunload', this.beforeUnloadHandler);
  },

  destroyed() {
    // Cleanup timers and event listeners
    if (this.debounceTimer) {
      clearTimeout(this.debounceTimer);
    }
    window.removeEventListener('beforeunload', this.beforeUnloadHandler);
  },

  save(value) {
    this.pushEvent('description_changed', { value });
    this.lastSavedValue = value;
    this.isDirty = false;
  }
};

export default AutoSaveTextarea;
