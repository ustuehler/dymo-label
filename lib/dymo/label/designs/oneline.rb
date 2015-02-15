description 'single line with maximum font size'

draw do |line, font_size=nil|
  if font_size.nil?
    font_size = height
  else
    font_size = font_size.to_f * 1.mm
  end

  styles :font_size => font_size, :text_anchor => 'start'
  text 0, height / 2.0 + (font_size / 2.0), line
end
