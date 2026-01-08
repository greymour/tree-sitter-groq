/**
 * @file Parser for the Groq query language used by the Sanity.io headless CMS
 * @author Kurt Steigleder
 * @license MIT
 */

/// <reference types="tree-sitter-cli/dsl" />
// @ts-check

module.exports = grammar({
  name: "groq",

  rules: {
    // TODO: add the actual grammar rules
    source_file: $ => "hello"
  }
});
