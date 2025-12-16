return {
  "nvim-tree/nvim-tree.lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local ok, nvim_tree = pcall(require, "nvim-tree")
    if not ok then
      vim.schedule(function()
        vim.notify("nvim-tree not available; run :Lazy sync", vim.log.levels.WARN)
      end)
      return
    end

    nvim_tree.setup({
      hijack_cursor = true,
      update_focused_file = { enable = true },
      view = { width = 34 },
    })
    vim.keymap.set("n", "<C-b>", "<cmd>NvimTreeToggle<CR>", { silent = true })
  end,
}
