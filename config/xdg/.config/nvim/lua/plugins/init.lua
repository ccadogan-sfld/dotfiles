-- Plugin specs (lazy.nvim): keep each plugin's config in its own module.

return {
  require("plugins.tree"),
  require("plugins.terminal"),
  require("plugins.telescope"),
  require("plugins.treesitter"),
  require("plugins.lsp"),
  require("plugins.cmp"),
}

