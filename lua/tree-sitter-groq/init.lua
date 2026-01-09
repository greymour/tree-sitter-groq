local M = {}

M.config = {
  ensure_installed = true,
}

local function register_parser()
  local ok, parsers = pcall(require, "nvim-treesitter.parsers")
  if not ok then
    return false
  end

  local parser_config = parsers.get_parser_configs()
  parser_config.groq = {
    install_info = {
      url = "https://github.com/sanity-io/tree-sitter-groq",
      files = { "src/parser.c" },
      branch = "main",
    },
    filetype = "groq",
  }
  return true
end

local function register_filetype()
  vim.filetype.add({
    extension = {
      groq = "groq",
    },
  })
end

function M.setup(opts)
  M.config = vim.tbl_deep_extend("force", M.config, opts or {})

  register_filetype()

  if not register_parser() then
    vim.notify(
      "[tree-sitter-groq] nvim-treesitter not found. Parser registration skipped.",
      vim.log.levels.WARN
    )
    return
  end

  if M.config.ensure_installed then
    local ok, install = pcall(require, "nvim-treesitter.install")
    if ok then
      local installed = #vim.api.nvim_get_runtime_file("parser/groq.so", false) > 0
      if not installed then
        install.ensure_installed({ "groq" })
      end
    end
  end
end

return M
