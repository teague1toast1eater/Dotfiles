return {
  {
    "RRethy/base16-nvim",
    priority = 1000,
    config = function()
      require("base16-colorscheme").setup({
        base00 = "#1c0f14",
        base01 = "#2a1519",
        base02 = "#43232b",
        base03 = "#7a5a58",
        base04 = "#b89c86",
        base05 = "#f6e6c0",
        base06 = "#fbeccb",
        base07 = "#fff3d6",
        base08 = "#e0453a",
        base09 = "#ee7b30",
        base0A = "#f5b82e",
        base0B = "#9bb86a",
        base0C = "#3fb5a8",
        base0D = "#6fa0b8",
        base0E = "#b0577e",
        base0F = "#a0522d",
      })
    end,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = function() end,
    },
  },
}
