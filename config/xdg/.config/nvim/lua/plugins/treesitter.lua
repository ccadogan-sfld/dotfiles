return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  lazy = false,
  config = function()
    local ok, ts = pcall(require, "nvim-treesitter")
    if not ok then
      vim.schedule(function()
        vim.notify("nvim-treesitter not available; run :Lazy sync", vim.log.levels.WARN)
      end)
      return
    end

    -- The rewrite does not enable highlighting automatically; Neovim provides it via vim.treesitter.start().
    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("DotfilesTreesitter", { clear = true }),
      pattern = { "python", "lua", "bash", "json", "toml", "yaml", "markdown", "vim", "vimdoc" },
      callback = function()
        pcall(vim.treesitter.start)
      end,
    })

    -- Avoid installing parsers during startup (can block on network/build toolchain).
    -- Install/update manually with `:TSUpdate` or `:lua require('nvim-treesitter').install({ 'python' })`.
  end,
}
