return {
  cmd = { 'elp', 'server' },
  filetypes = { 'erlang' },
  root_markers = { 'rebar.config', 'erlang.mk', '.git' },
  settings = {
    elp = {
      diagnostics = {
        disabled = {
          "W0038",
        }
      }
    }
  },
}
