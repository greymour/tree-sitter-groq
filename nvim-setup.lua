-- GROQ Tree-sitter setup for Neovim
-- Add this to your init.lua or create a separate plugin file

local M = {}

-- 1. Register the GROQ parser with nvim-treesitter
function M.setup_parser()
  local parser_config = require("nvim-treesitter.parsers").get_parser_configs()

  parser_config.groq = {
    install_info = {
      -- CHANGE THIS to your local path or a GitHub URL
      url = vim.fn.expand("~/code/tree-sitter-groq"),
      files = { "src/parser.c" },
      branch = "main",
      generate_requires_npm = false,
      requires_generate_from_grammar = false,
    },
    filetype = "groq",
  }
end

-- 2. Register the .groq filetype
function M.setup_filetype()
  vim.filetype.add({
    extension = {
      groq = "groq",
    },
  })
end

-- 3. Register GROQ as an injection language for JS/TS
-- This tells nvim-treesitter that "groq" is a valid injection target
function M.setup_injection()
  -- Ensure groq is recognized as an injection language
  vim.treesitter.language.register("groq", "groq")
end

-- 4. Full setup function
function M.setup(opts)
  opts = opts or {}

  M.setup_parser()
  M.setup_filetype()
  M.setup_injection()

  -- Install the parser if requested
  if opts.install then
    vim.cmd("TSInstall groq")
  end
end

return M

--[[
USAGE:

1. Add this file to your Neovim config (e.g., ~/.config/nvim/lua/groq-setup.lua)

2. In your init.lua, add:

   require("groq-setup").setup()

3. Install the parser:

   :TSInstall groq

4. Copy the query files:

   mkdir -p ~/.config/nvim/queries/groq
   cp /path/to/tree-sitter-groq/queries/highlights.scm ~/.config/nvim/queries/groq/

   mkdir -p ~/.config/nvim/after/queries/typescript
   mkdir -p ~/.config/nvim/after/queries/javascript
   mkdir -p ~/.config/nvim/after/queries/tsx

   cp /path/to/tree-sitter-groq/queries/injections-javascript.scm ~/.config/nvim/after/queries/typescript/injections.scm
   cp /path/to/tree-sitter-groq/queries/injections-javascript.scm ~/.config/nvim/after/queries/javascript/injections.scm
   cp /path/to/tree-sitter-groq/queries/injections-javascript.scm ~/.config/nvim/after/queries/tsx/injections.scm

5. Restart Neovim and test with:

   :InspectTree          -- View parse tree
   :Inspect              -- View highlight groups under cursor
   :TSInstallInfo        -- Verify groq is installed

TROUBLESHOOTING:

- If highlighting doesn't work, check :TSInstallInfo to verify groq is installed
- Use :InspectTree on a .ts file to see if the comment and template_string are siblings
- Ensure the queries use 'after/queries' not just 'queries' to extend existing ones
- Check :messages for any tree-sitter errors

]]
