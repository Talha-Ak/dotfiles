return {
  settings = {
    texlab = {
      build = { onSave = true },
      forwardSearch = (vim.fn.executable("zathura") == 1) and {
        executable = "zathura",
        args = { "--synctex-forward", "%l:1:%f", "%p" },
      } or {},
    },
  },
}
