# tree-sitter-groq

Tree-sitter grammar and Neovim plugin for [GROQ](https://www.sanity.io/docs/groq) (Graph-Relational Object Queries), the query language used by [Sanity.io](https://www.sanity.io/).

## Features

- Full Tree-sitter grammar for GROQ
- Syntax highlighting for `.groq` files
- Syntax highlighting injected into JavaScript/TypeScript template literals:
  - `/* groq */` comment markers: `` const query = /* groq */ `*[_type == "movie"]` ``
  - `defineQuery()` function calls: `` defineQuery(`*[_type == "movie"]`) ``
  - `groq` tagged templates: `` groq`*[_type == "movie"]` ``

### Why is this not formally published as a Tree-sitter grammar?
Because I'm lazy! One day I'll follow the [docs](https://tree-sitter.github.io/tree-sitter/creating-parsers/6-publishing.html) and do it.

## Installation

### lazy.nvim

```lua
{
  "sanity-io/tree-sitter-groq",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  config = function()
    require("tree-sitter-groq").setup()
  end,
}
```

### packer.nvim

```lua
use {
  "sanity-io/tree-sitter-groq",
  requires = { "nvim-treesitter/nvim-treesitter" },
  config = function()
    require("tree-sitter-groq").setup()
  end,
}
```

### vim-plug

```vim
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'sanity-io/tree-sitter-groq'
```

## Setup

After installation, run `:TSInstall groq` to install the parser.

### Configuration

```lua
require("tree-sitter-groq").setup({
  -- Automatically install the groq parser (default: true)
  ensure_installed = true,
})
```

## Usage

### Standalone GROQ Files

Create a file with the `.groq` extension and it will automatically be highlighted.

### In JavaScript/TypeScript

GROQ queries embedded in JS/TS files are automatically highlighted when using one of these patterns:

```typescript
// Pattern 1: Block comment marker
const query1 = /* groq */ `
  *[_type == "movie"] {
    title,
    director->name
  }
`;

// Pattern 2: defineQuery function (from @sanity/client)
import { defineQuery } from "groq";
const query2 = defineQuery(`
  *[_type == "movie"] {
    title
  }
`);

// Pattern 3: Tagged template literal
import groq from "groq";
const query3 = groq`
  *[_type == "movie"]
`;
```

## Health Check

Run `:checkhealth tree-sitter-groq` to verify the installation.

## Grammar Features

The GROQ grammar supports:

- All literal types: strings, numbers, booleans, null
- Operators: arithmetic, comparison, logical
- Special references: `@` (this), `^` (parent), `*` (everything)
- Filters: `*[_type == "movie"]`
- Projections: `{ title, "director": director->name }`
- Slicing: `[0..10]`, `[0...10]`
- Dereferencing: `author->name`
- Pipe expressions: `*[_type == "movie"] | order(releaseYear desc)`
- Functions: `count()`, `defined()`, `coalesce()`, `select()`, `order()`, etc.
- Comments: `// line comment`

## Development

### Building the Parser

```bash
npm install
npx tree-sitter generate
```

### Running Tests

```bash
npx tree-sitter test
```

## License

MIT
