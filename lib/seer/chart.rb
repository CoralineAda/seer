module Seer

  module Chart #:nodoc:

    attr_accessor :chart_element
    
    DEFAULT_COLORS = ['#324F69','#919E4B', '#A34D4D', '#BEC8BE']

    def in_element=(elem)
      @chart_element = elem
    end
    
    def colors=(colors_list)
      raise ArgumentError, "Invalid color option: #{colors_list}" unless colors_list.is_a?(Array) && colors_list.inject([]){|set,color| set << color if Seer.valid_hex_number?(color); set }.size == colors_list.size
      @colors = colors_list
    end
    
    def formatted_colors
      if @colors.include?('darker')
        @colors
      else
        "[#{@colors.map{|color| "'#{color.gsub(/\#/,'')}'"} * ','}]"
      end
    end
    
    def data_columns(object_label, value_label)
      _data_columns =  "            data.addRows(#{data_table.size});\r"
      _data_columns << "            data.addColumn('string', '#{label_method}');\r"
      _data_columns << "            data.addColumn('number', '#{data_method}');\r"
      _data_columns
    end
    
    def options
      _options = ""
      nonstring_options.each do |opt|
        if opt == :colors
          _options << "            options['#{opt.to_s.camelize(:lower)}'] = #{self.send(:formatted_colors)};\r" if self.send(opt)
        else
          _options << "            options['#{opt.to_s.camelize(:lower)}'] = #{self.send(opt)};\r" if self.send(opt)
        end
      end
      string_options.each do |opt|
        _options << "            options['#{opt.to_s.camelize(:lower)}'] = '#{self.send(opt)}';\r" if self.send(opt)
      end
      _options
    end
        
  end

end