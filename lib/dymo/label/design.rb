require 'rvg/rvg'

DOTS_PER_MM = 8
Magick::RVG::dpi = DOTS_PER_MM * 10 * 2.54

module Dymo::Label
  class Design
    @@by_name = {}

    def self.each(&block)
      @@by_name.values.each(&block)
    end

    def self.find(name)
      @@by_name[name.to_sym] || @@by_name.values.find { |design|
        design.aliases.include? name.to_sym
      }
    end

    def self.register(design)
      @@by_name[design.name.to_sym] = design
    end

    attr_accessor :name
    attr_accessor :aliases
    attr_accessor :description
    attr_accessor :draw_block

    def initialize
      @aliases = []
      @canvas = nil
    end

    def draw_usage
      usage = [name]

      # kind will always be :opt for blocks, but arity is correct
      req_args = draw_block.parameters[0...draw_block.arity].map { |kind, name| name }
      usage << ('<' + req_args.join('><') + '>') unless req_args.empty?

      opt_args = draw_block.parameters[draw_block.arity..-1].map { |kind, name| name }
      usage << ('[' + opt_args.join('][') + ']') unless opt_args.empty?

      usage.join ' '
    end

    def canvas(*args)
      dots_per_mm = 8
      Magick::RVG::dpi = dots_per_mm * 10 * 2.54

      width = 50.mm.round
      height = 12.mm.round

      if args.size < draw_block.arity or args.size > draw_block.parameters.size
        abort "Usage: #{draw_usage}"
      end

      Magick::RVG.new(width, height) do |rvg|
        rvg.background_fill = 'white'
        rvg.instance_exec(*args, &draw_block)
      end
    end

    def draw(*args)
      canvas(*args).draw
    end

    def preview(*args)
      rvg = canvas(*args)
      rvg.viewbox(-5.mm, 0.5.mm, rvg.width, rvg.height).draw
    end
  end
end
