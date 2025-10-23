require('nightfox').setup({
  options = {
    styles = {
      comments = "italic",
      keywords = "bold",
      types = "italic,bold",
    },
    colorblind = {
      enable = true,
      simulate_only = false,
      severity = {
        protan = 0.5,
        deutan = 0.5,
        tritan = 0.0,
      },
    },
  }
})
