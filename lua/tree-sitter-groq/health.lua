local M = {}

M.check = function()
  vim.health.start("tree-sitter-groq")

  -- Check nvim-treesitter
  local ok, _ = pcall(require, "nvim-treesitter")
  if ok then
    vim.health.ok("nvim-treesitter is installed")
  else
    vim.health.error("nvim-treesitter is not installed", {
      "Install nvim-treesitter: https://github.com/nvim-treesitter/nvim-treesitter",
    })
    return
  end

  -- Check if groq parser is installed
  local parser_installed = #vim.api.nvim_get_runtime_file("parser/groq.so", false) > 0
    or #vim.api.nvim_get_runtime_file("parser/groq.dylib", false) > 0
  if parser_installed then
    vim.health.ok("GROQ parser is installed")
  else
    vim.health.warn("GROQ parser is not installed", {
      "Run :TSInstall groq",
    })
  end

  -- Check if highlight queries exist
  local highlights = vim.api.nvim_get_runtime_file("queries/groq/highlights.scm", false)
  if #highlights > 0 then
    vim.health.ok("GROQ highlight queries found")
  else
    vim.health.error("GROQ highlight queries not found")
  end

  -- Check if injection queries exist
  local injections = vim.api.nvim_get_runtime_file("after/queries/typescript/injections.scm", false)
  if #injections > 0 then
    vim.health.ok("TypeScript injection queries found")
  else
    vim.health.warn("TypeScript injection queries not found", {
      "GROQ highlighting in TypeScript files may not work",
    })
  end

  -- Test parsing
  local test_ok, result = pcall(function()
    local parser = vim.treesitter.get_string_parser('*[_type == "test"]', "groq")
    local tree = parser:parse()[1]
    return tree:root():type()
  end)
  if test_ok and result == "source_file" then
    vim.health.ok("GROQ parser works correctly")
  else
    vim.health.error("GROQ parser failed to parse test input", {
      "Try reinstalling: :TSInstall! groq",
    })
  end
end

return M
