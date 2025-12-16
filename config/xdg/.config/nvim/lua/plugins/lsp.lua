return {
  "neovim/nvim-lspconfig",
  dependencies = {
    { "williamboman/mason.nvim", config = true },
    "williamboman/mason-lspconfig.nvim",
  },
  config = function()
    local ok_lsp, lspconfig = pcall(require, "lspconfig")
    if not ok_lsp then
      vim.schedule(function()
        vim.notify("nvim-lspconfig not available; run :Lazy sync", vim.log.levels.WARN)
      end)
      return
    end

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    local ok_cmp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
    if ok_cmp then
      capabilities = cmp_lsp.default_capabilities(capabilities)
    end

    local ok_mason_lsp, mason_lspconfig = pcall(require, "mason-lspconfig")
    if not ok_mason_lsp then
      vim.schedule(function()
        vim.notify("mason-lspconfig not available; run :Lazy sync", vim.log.levels.WARN)
      end)
      return
    end

    mason_lspconfig.setup({
      ensure_installed = { "pyright" },
      handlers = {
        function(server_name)
          lspconfig[server_name].setup({ capabilities = capabilities })
        end,
      },
    })

    vim.keymap.set("n", "gd", vim.lsp.buf.definition, { silent = true })
    vim.keymap.set("n", "gr", vim.lsp.buf.references, { silent = true })
    vim.keymap.set("n", "K", vim.lsp.buf.hover, { silent = true })
    vim.keymap.set("n", "<F2>", vim.lsp.buf.rename, { silent = true })
  end,
}
