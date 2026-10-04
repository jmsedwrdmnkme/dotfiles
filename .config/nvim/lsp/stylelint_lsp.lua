return {
  cmd = {
    "stylelint-language-server", "--stdio"
  },
  filetypes = {
    "astro", "css", "html", "less", "scss", "vue"
  },
  root_markers = {
    ".git", "composer.json"
  },
  settings = {
    stylelint = {
      snippet = { "css", "postcss" },
      validate = { "css", "postcss" }
    }
  }
}
