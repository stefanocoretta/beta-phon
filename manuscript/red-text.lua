-- red-text.lua
function Span(el)
  if el.classes:includes('red') then
    local fmt = FORMAT:match("([^+]+)")  -- get main format without variants

    if fmt == "html" then
      -- For HTML, add style attribute
      el.attributes['style'] = 'color: red;'
      return el

    elseif fmt == "latex" then
      -- For LaTeX/PDF, wrap in \textcolor{red}{...}
      return pandoc.RawInline('latex', '\\textcolor{red}{' .. pandoc.utils.stringify(el) .. '}')

    elseif fmt == "docx" then
      -- For Word, use raw OpenXML
      local text = pandoc.utils.stringify(el)
      local openxml = string.format([[
<w:r>
  <w:rPr><w:color w:val="FF0000"/></w:rPr>
  <w:t>%s</w:t>
</w:r>
      ]], text)
      return pandoc.RawInline('openxml', openxml)
    end
  end
  return nil
end
