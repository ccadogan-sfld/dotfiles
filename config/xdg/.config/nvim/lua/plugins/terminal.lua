return {
  "akinsho/toggleterm.nvim",
  version = "*",
  config = function()
    local ok, toggleterm = pcall(require, "toggleterm")
    if not ok then
      vim.schedule(function()
        vim.notify("toggleterm not available; run :Lazy sync", vim.log.levels.WARN)
      end)
      return
    end

    toggleterm.setup({ direction = "float", open_mapping = [[<C-\>]] })
  end,
}
