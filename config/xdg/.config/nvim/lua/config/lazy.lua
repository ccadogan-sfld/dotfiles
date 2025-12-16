-- Plugin bootstrap and setup via lazy.nvim.

local uv = vim.uv or vim.loop
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.schedule(function()
      vim.notify("lazy.nvim bootstrap failed; skipping plugins (install manually or allow network)", vim.log.levels.WARN)
    end)
    return
  end
end

vim.opt.rtp:prepend(lazypath)

local ok_lazy, lazy = pcall(require, "lazy")
if not ok_lazy then
  vim.schedule(function()
    vim.notify("lazy.nvim not found; skipping plugins (install lazy.nvim or allow bootstrap)", vim.log.levels.WARN)
  end)
  return
end

lazy.setup(require("plugins"), {
  install = { missing = true },
})
