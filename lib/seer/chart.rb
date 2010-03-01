module Seer

  module Chart #:nodoc:

    attr_accessor :chart_element, :colors
    
    DEFAULT_COLORS = ['#324F69','#919E4B', '#A34D4D', '#BEC8BE']
    DEFAULT_LEGEND_LOCATION = 'bottom'
    DEFAULT_HEIGHT = 350
    DEFAULT_WIDTH = 550
    
    def in_element=(elem)
      @chart_element = elem
    end
    
    def colors=(colors_list)
      unless colors_list.include?('darker')
        raise ArgumentError, "Invalid color option: #{colors_list}" unless colors_list.is_a?(Array)
        colors_list.each do |color|
          raise ArgumentError, "Invalid color option: #{colors_list}" unless Seer.valid_hex_number?(color)
        end
      end
      @colors = colors_list
    end
    
    def formatted_colors
      if @colors.include?('darker')
        @colors
      else
        "[#{@colors.map{|color| "'#{color.gsub(/\#/,'')}'"} * ','}]"
      end
    end
    
    def data_columns
      _data_columns =  "            data.addRows(#{data_table.size});\r"
      _data_columns << "            data.addColumn('string', '#{label_method}');\r"
      _data_columns << "            data.addColumn('number', '#{data_method}');\r"
      _data_columns
    end
    
    def options
      _options = ""
      nonstring_options.each do |opt|
        next unless self.send(opt)
        if opt == :colors
          _options << "            options['#{opt.to_s.camelize(:lower)}'] = #{self.send(:formatted_colors)};\r"
        else
          _options << "            options['#{opt.to_s.camelize(:lower)}'] = #{self.send(opt)};\r"
        end
      end
      string_options.each do |opt|
        next unless self.send(opt)
        _options << "            options['#{opt.to_s.camelize(:lower)}'] = '#{self.send(opt)}';\r"
      end
      _options
    end
        
  end

end