# commentcopy.nvim

A plugin that duplicates your current line or visual selection, comments out the original text using Neovim's native commenting engine, and places your cursor exactly where you started inside the clean, duplicated block. Perfect for debugging when you just want to change the code for a second.

## ⚡️ Requirements

- Neovim 0.10.0+ (utilizes the built-in native `gc` commenting framework)

## 📦 Installation & Setup

### 1. Using [lazy.nvim](https://github.com) (Recommended)

Because `commentcopy.nvim` does not force default keymaps during initialization, you can map keys directly through Lazy's `keys` paradigm. This achieves optimal lazy-loading automatically without requiring explicit configuration overrides:

```lua
return {
  "amadanmath/commentcopy.nvim",
  keys = {
    { 
      "gC", 
      function() require("commentcopy").comment_copy_range(false) end, 
      mode = "n", 
      desc = "Duplicate line and comment original" 
    },
    { 
      "gC", 
      function() require("commentcopy").comment_copy_range(true) end, 
      mode = "x", 
      desc = "Duplicate selection and comment original" 
    },
  },
  config = true,
}
```

### 2. Using Traditional Package Managers (`vim-plug`, `pckr.nvim`, `mini.deps`)

For non-deferred setups, initialize the plugin and bind the exposed Lua runner functions using the native Neovim keymap API:

```lua
-- Initialize plugin state
require("commentcopy").setup()

-- Create normal and visual mode bindings
vim.keymap.set('n', 'gC', function() 
  require("commentcopy").comment_copy_range(false) 
end, { desc = "Duplicate line and comment original" })

vim.keymap.set('x', 'gC', function() 
  require("commentcopy").comment_copy_range(true) 
end, { desc = "Duplicate selection and comment original" })
```

## 🚀 Usage

1. **Normal Mode**: Position your cursor anywhere on a line and press `gC`. The line is commented, a raw duplicate appears directly below it, and your cursor remains on the duplicate at its exact original column.
2. **Visual Mode**: Select a block of text line-wise and press `gC`. The selected block is turned into a comment block, a clean copy is injected right under it, and your cursor transitions down to match your original selection row offset.

## 📄 License

MIT
