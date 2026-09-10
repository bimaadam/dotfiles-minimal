---@type LazySpec
return {
  "AstroNvim/astrocommunity",
  -- Languages & Packs
  { import = "astrocommunity.pack.lua" },
  { import = "astrocommunity.pack.typescript" },
  { import = "astrocommunity.pack.go" },
  { import = "astrocommunity.pack.rust" },
  { import = "astrocommunity.pack.java" },
  { import = "astrocommunity.pack.html-css" },
  { import = "astrocommunity.pack.php" },
  { import = "astrocommunity.pack.sql" },
  { import = "astrocommunity.pack.yaml" },
  { import = "astrocommunity.pack.helm" },
  { import = "astrocommunity.pack.docker" },
  { import = "astrocommunity.pack.json" },
  { import = "astrocommunity.pack.bash" },
  { import = "astrocommunity.pack.hyprlang" },

  -- Monochrome Theme
  { import = "astrocommunity.colorscheme.lackluster-nvim" },

  -- Discord Rich Presence
}
