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
}
