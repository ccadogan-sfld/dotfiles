return {
  "nvim-telescope/telescope.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local ok, telescope = pcall(require, "telescope")
    if not ok then
      vim.schedule(function()
        vim.notify("telescope not available; run :Lazy sync", vim.log.levels.WARN)
      end)
      return
    end

    telescope.setup({})
    vim.keymap.set("n", "<C-p>", "<cmd>Telescope find_files<CR>", { silent = true })
    vim.keymap.set("n", "<C-f>", "<cmd>Telescope live_grep<CR>", { silent = true })
  end,
}
