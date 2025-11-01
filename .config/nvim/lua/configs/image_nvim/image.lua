require('image').setup {
  backend = 'kitty',
  processor = 'magick_cli',
  rocks = {
    hererocks = true,
  },
  integrations = {
    markdown = {
      enabled = true, -- Enable image rendering for Markdown files
      clear_in_insert_mode = false, -- Do not clear images in insert mode
      download_remote_images = true, -- Automatically download and display remote images
      only_render_image_at_cursor = false, -- Render images across the entire document, not just at the cursor
      filetypes = { 'markdown', 'vimwiki' }, -- File types for this integration
    },
    neorg = {
      enabled = true, -- Enable image rendering for Neorg files
      clear_in_insert_mode = false,
      download_remote_images = true,
      only_render_image_at_cursor = false,
      filetypes = { 'norg' }, -- File type for Neorg
    },
    -- Optional integrations (disabled)
    html = { enabled = false },
    css = { enabled = false },
  },

  max_width = nil, -- No maximum width for images
  max_height = nil, -- No maximum height for images
  max_height_window_percentage = 50, -- Maximum height of images relative to the window height

  window_overlap_clear_enabled = false, -- Do not clear images when windows overlap
  window_overlap_clear_ft_ignore = { 'cmp_menu', 'cmp_docs', '' }, -- Ignore filetypes when handling overlap

  editor_only_render_when_focused = true, -- Render images even when the editor is not in focus
  tmux_show_only_in_active_window = true, -- Disable Tmux-specific window hiding behavior

  hijack_file_patterns = { '*.png', '*.jpg', '*.jpeg', '*.gif', '*.webp', '*.avif' }, -- File patterns for automatic image rendering
}
