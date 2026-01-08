/**
 * @file Parser for the Groq query language used by the Sanity.io headless CMS
 * @author Kurt Steigleder
 * @license MIT
 */

/// <reference types="tree-sitter-cli/dsl" />
// @ts-check

const PREC = {
  PAIR: 1,
  OR: 2,
  AND: 3,
  NOT: 4,
  COMPARE: 5,
  IN_MATCH: 6,
  ADD: 7,
  MULT: 8,
  EXP: 9,
  UNARY: 10,
  POSTFIX: 11,
  PIPE: 12,
  ACCESS: 13,
};

module.exports = grammar({
  name: "groq",

  extras: $ => [
    /\s/,
    $.comment,
  ],

  word: $ => $.identifier,

  conflicts: $ => [],

  supertypes: $ => [
    $._expression,
    $._literal,
  ],

  rules: {
    source_file: $ => optional($._expression),

    _expression: $ => choice(
      $._literal,
      $.identifier,
      $.variable,
      $.this,
      $.parent,
      $.everything,
      $.parenthesized_expression,
      $.unary_expression,
      $.binary_expression,
      $.and_expression,
      $.or_expression,
      $.not_expression,
      $.comparison_expression,
      $.in_expression,
      $.match_expression,
      $.pipe_expression,
      $.access_expression,
      $.subscript_expression,
      $.dereference_expression,
      $.projection_expression,
      $.function_call,
      $.array,
      $.object,
      $.pair,
      $.asc_expression,
      $.desc_expression,
    ),

    // Literals
    _literal: $ => choice(
      $.null,
      $.true,
      $.false,
      $.number,
      $.string,
    ),

    null: _ => "null",
    true: _ => "true",
    false: _ => "false",

    number: _ => {
      const integer = /0|[1-9]\d*/;
      const decimal = seq(".", /\d+/);
      const exponent = seq(/[eE][+-]?/, /\d+/);
      return token(seq(
        optional("-"),
        integer,
        optional(decimal),
        optional(exponent),
      ));
    },

    string: $ => choice(
      $.double_quoted_string,
      $.single_quoted_string,
    ),

    double_quoted_string: $ => seq(
      '"',
      repeat(choice(
        /[^"\\]+/,
        $.escape_sequence,
      )),
      '"',
    ),

    single_quoted_string: $ => seq(
      "'",
      repeat(choice(
        /[^'\\]+/,
        $.escape_sequence,
      )),
      "'",
    ),

    escape_sequence: _ => token.immediate(seq(
      "\\",
      choice(
        /["\\'\/bfnrt]/,
        /u[0-9a-fA-F]{4}/,
      ),
    )),

    // Identifiers and variables
    identifier: _ => /[_A-Za-z][_0-9A-Za-z]*/,

    variable: _ => /\$[_A-Za-z][_0-9A-Za-z]*/,

    // Special nullary operators
    this: _ => "@",
    parent: _ => "^",
    everything: _ => "*",

    // Parenthesized expression
    parenthesized_expression: $ => seq(
      "(",
      $._expression,
      ")",
    ),

    // Unary expressions
    unary_expression: $ => prec.left(PREC.UNARY, seq(
      field("operator", choice("-", "+")),
      field("operand", $._expression),
    )),

    not_expression: $ => prec.right(PREC.NOT, seq(
      "!",
      field("operand", $._expression),
    )),

    // Binary expressions
    binary_expression: $ => choice(
      prec.left(PREC.ADD, seq(
        field("left", $._expression),
        field("operator", choice("+", "-")),
        field("right", $._expression),
      )),
      prec.left(PREC.MULT, seq(
        field("left", $._expression),
        field("operator", choice("*", "/", "%")),
        field("right", $._expression),
      )),
      prec.right(PREC.EXP, seq(
        field("left", $._expression),
        field("operator", "**"),
        field("right", $._expression),
      )),
    ),

    // Logical expressions
    and_expression: $ => prec.left(PREC.AND, seq(
      field("left", $._expression),
      "&&",
      field("right", $._expression),
    )),

    or_expression: $ => prec.left(PREC.OR, seq(
      field("left", $._expression),
      "||",
      field("right", $._expression),
    )),

    // Comparison expressions
    comparison_expression: $ => prec.left(PREC.COMPARE, seq(
      field("left", $._expression),
      field("operator", choice("==", "!=", "<", ">", "<=", ">=")),
      field("right", $._expression),
    )),

    // In and match expressions
    in_expression: $ => prec.left(PREC.IN_MATCH, seq(
      field("left", $._expression),
      "in",
      field("right", $._expression),
    )),

    match_expression: $ => prec.left(PREC.IN_MATCH, seq(
      field("left", $._expression),
      "match",
      field("right", $._expression),
    )),

    // Pipe expression
    pipe_expression: $ => prec.left(PREC.PIPE, seq(
      field("left", $._expression),
      "|",
      field("right", $._expression),
    )),

    // Access expression (dot notation)
    access_expression: $ => prec.left(PREC.ACCESS, seq(
      field("base", $._expression),
      ".",
      field("member", choice($.identifier, $.parent, $.this)),
    )),

    // Subscript expression (bracket access - handles index, filter, slice, and array all)
    subscript_expression: $ => prec.left(PREC.ACCESS, seq(
      field("base", $._expression),
      "[",
      optional(choice(
        seq(
          field("start", optional($._expression)),
          field("operator", choice("..", "...")),
          field("end", optional($._expression)),
        ),
        field("index", $._expression),
      )),
      "]",
    )),

    // Dereference expression (arrow)
    dereference_expression: $ => prec.left(PREC.ACCESS, seq(
      field("base", $._expression),
      "->",
      field("member", optional($.identifier)),
    )),

    // Projection expression
    projection_expression: $ => prec.left(PREC.ACCESS, seq(
      field("base", $._expression),
      field("projection", $.projection),
    )),


    // Projection (object-like structure for selecting fields)
    projection: $ => seq(
      "{",
      optional(seq(
        $._projection_entry,
        repeat(seq(",", $._projection_entry)),
        optional(","),
      )),
      "}",
    ),

    _projection_entry: $ => choice(
      $.spread,
      $.projection_pair,
      $._expression,
    ),

    projection_pair: $ => prec(PREC.PAIR + 1, seq(
      field("key", choice($.string, $.identifier)),
      ":",
      field("value", $._expression),
    )),

    // Spread operator
    spread: $ => seq(
      "...",
      optional($._expression),
    ),

    // Pair with fat arrow (used in select())
    pair: $ => prec.right(PREC.PAIR, seq(
      field("condition", $._expression),
      "=>",
      field("value", $._expression),
    )),

    // Ordering keywords for use in order()
    asc_expression: $ => prec.left(PREC.POSTFIX, seq(
      field("expression", $._expression),
      "asc",
    )),

    desc_expression: $ => prec.left(PREC.POSTFIX, seq(
      field("expression", $._expression),
      "desc",
    )),

    // Array literal
    array: $ => seq(
      "[",
      optional(seq(
        $._array_element,
        repeat(seq(",", $._array_element)),
        optional(","),
      )),
      "]",
    ),

    _array_element: $ => choice(
      $._expression,
      $.spread,
    ),

    // Object literal
    object: $ => seq(
      "{",
      optional(seq(
        $.object_pair,
        repeat(seq(",", $.object_pair)),
        optional(","),
      )),
      "}",
    ),

    object_pair: $ => seq(
      field("key", choice($.string, $.identifier)),
      ":",
      field("value", $._expression),
    ),

    // Function calls
    function_call: $ => seq(
      field("name", $.identifier),
      "(",
      optional(seq(
        $._function_argument,
        repeat(seq(",", $._function_argument)),
        optional(","),
      )),
      ")",
    ),

    _function_argument: $ => $._expression,

    // Comments
    comment: _ => token(seq("//", /.*/)),
  },
});
