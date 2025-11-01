local ls = require 'luasnip'
local s, t, i = ls.snippet, ls.text_node, ls.insert_node
local fmt = require('luasnip.extras.fmt').fmt

return {
    s(
        'fn',
        fmt(
            [[
function {}({}) {{
  {}
}}
]],
            { i(1), i(2), i(3) }
        )
    ),

    s(
        'afn',
        fmt(
            [[
   const {} = ({}) => {{
  {}
   }}
   ]],
            { i(1, ''), i(2, ''), i(3, '') }
        )
    ),

    s('vl', {
        t 'let ',
        i(1),
        t ' = ',
    }),

    s('vc', {
        t 'const ',
        i(1),
        t ' = ',
    }),
}

-- s('clg', {
--   t 'console.log(',
--   i(1),
--   t ');',
-- }),
--
-- s('clo', {
--   t 'console.log("',
--   i(1),
--   t '", ',
--   i(2),
--   t ');',
-- }),
