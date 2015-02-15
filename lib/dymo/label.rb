module Dymo
  module Label
  end
end

require 'dymo/label/design'
require 'dymo/label/design/dsl'
require 'dymo/label/version'

designs_dir = File.join(File.dirname(__FILE__), 'label', 'designs')

Dir.entries(designs_dir).each do |entry|
  if entry.end_with?('.rb')
    design = Dymo::Label::Design.load_file(File.join(designs_dir, entry))
    Dymo::Label::Design.register design
  end
end
