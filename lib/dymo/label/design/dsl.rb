module Dymo::Label
  class Design::DSL
    def initialize(text, source)
      @design = Design.new
      instance_eval text, source
    end

    def description(single_line)
      @design.description = single_line
    end

    def draw(&block)
      @design.draw_block = block
    end

    def to_design
      @design.clone
    end
  end

  class Design
    def self.load_file(filename)
      design = Design::DSL.new(File.read(filename), filename).to_design
      design.name ||= File.basename(filename, '.rb')
      design
    end
  end
end
