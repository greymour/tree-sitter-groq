#!/bin/bash
# Install tree-sitter-groq for Neovim
# Run from the tree-sitter-groq directory

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
NVIM_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"

echo "Installing tree-sitter-groq for Neovim..."
echo "Source: $SCRIPT_DIR"
echo "Target: $NVIM_CONFIG"
echo ""

# Create query directories
echo "Creating query directories..."
mkdir -p "$NVIM_CONFIG/queries/groq"
mkdir -p "$NVIM_CONFIG/after/queries/typescript"
mkdir -p "$NVIM_CONFIG/after/queries/javascript"
mkdir -p "$NVIM_CONFIG/after/queries/tsx"
mkdir -p "$NVIM_CONFIG/after/queries/jsx"

# Copy GROQ highlights
echo "Copying GROQ highlight queries..."
cp "$SCRIPT_DIR/queries/highlights.scm" "$NVIM_CONFIG/queries/groq/"

# Copy injection queries for JS/TS
echo "Copying injection queries for TypeScript/JavaScript..."
cp "$SCRIPT_DIR/editors/nvim-injections.scm" "$NVIM_CONFIG/after/queries/typescript/injections.scm"
cp "$SCRIPT_DIR/editors/nvim-injections.scm" "$NVIM_CONFIG/after/queries/javascript/injections.scm"
cp "$SCRIPT_DIR/editors/nvim-injections.scm" "$NVIM_CONFIG/after/queries/tsx/injections.scm"
cp "$SCRIPT_DIR/editors/nvim-injections.scm" "$NVIM_CONFIG/after/queries/jsx/injections.scm"

# Copy setup lua file
echo "Copying Neovim setup module..."
mkdir -p "$NVIM_CONFIG/lua"
cp "$SCRIPT_DIR/nvim-setup.lua" "$NVIM_CONFIG/lua/groq-treesitter.lua"

echo ""
echo "Installation complete!"
echo ""
echo "Next steps:"
echo ""
echo "1. Add this to your init.lua:"
echo ""
echo '   require("groq-treesitter").setup()'
echo ""
echo "2. Restart Neovim and install the parser:"
echo ""
echo "   :TSInstall groq"
echo ""
echo "3. Verify installation:"
echo ""
echo "   :TSInstallInfo   (should show 'groq' as installed)"
echo "   :InspectTree     (on a .groq file)"
echo ""
echo "4. Test GROQ injection in TypeScript:"
echo ""
echo '   const query = /* groq */ `*[_type == "movie"]`;'
echo ""
