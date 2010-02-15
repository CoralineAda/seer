module Seer

  # For details on the chart options, see the Google API docs at 
  # http://code.google.com/apis/visualization/documentation/gallery/barchart.html
  #
  # =USAGE=
  # 
  # In your view:
  #
  #   <%= visualize(
  #         @widgets, 
  #         :as => :bar_chart,
  #         :chart_options => {
  #           :height => '300px',
  #           :width => '350px',
  #           :is_3_d => true,
  #           :colors => [ {color:'FF0000', darker:'680000'}, {color:'cyan', darker:'deepskyblue'} ]
  #         },
  #         :label_method => 'name',
  #         :x_axis => { :label => 'Date',     :method => 'updated_at' },
  #         :y_axis => { :label => 'Searches', :method => 'searches' }
  #        )
  #    -%>
  #   
  #   <div id="chart" class="chart"></div>
  #
  class BarChart
  
    include Seer::Chart
    
    # Chart options accessors
    attr_accessor :axis_color, :axis_background_color, :axis_font_size, :background_color, :border_color, :colors, :data_table, :enable_tooltip, :focus_border_color, :height, :is_3_d, :is_stacked, :legend, :legend_background_color, :legend_font_size, :legend_text_color, :log_scale, :max, :min, :reverse_axis, :show_categories, :title, :title_x, :title_y, :title_color, :title_font_size, :tooltip_font_size, :tooltip_height, :tooltip_width, :width
    
    # Graph data
    attr_accessor :label_method, :x_axis_label, :x_axis_method, :y_axis_label, :y_axis_method
    
    def initialize(args={})

      # Standard options
      args.each{ |method,arg| self.send("#{method}=",arg) if self.respond_to?(method) }

      # Chart options
      args[:chart_options].each{ |method, arg| self.send("#{method}=",arg) if self.respond_to?(method) }

      # Handle defaults      
      @colors ||= args[:chart_options][:colors] || DEFAULT_COLORS
      @legend ||= args[:chart_options][:legend] || 'bottom'
      @height ||= args[:chart_options][:height] || '347'
      @width  ||= args[:chart_options][:width] || '556'
      @is_3_d ||= args[:chart_options][:is_3_d]

      @data_table = []
      
    end
  
    def data_table=(data)
      data.each_with_index do |datum, column|
        @data_table << [
          "            data.setValue(#{column}, 0,'#{datum.send(label_method)}');\r",
          "            data.setValue(#{column}, 1, #{datum.send(y_axis_method)});\r"
        ]
      end
    end
  
    def is_3_d
      @is_3_d.blank? ? false : @is_3_d
    end

    def nonstring_options
      [:axis_font_size, :colors, :enable_tooltip, :height, :is_3_d, :is_stacked, :legend_font_size, :log_scale, :max, :min, :reverse_axis, :show_categories, :title_font_size, :tooltip_font_size, :tooltip_width, :width]
    end
    
    def string_options
      [:axis_color, :axis_background_color, :background_color, :border_color, :focus_border_color, :legend, :legend_background_color, :legend_text_color, :title, :title_x, :title_y, :title_color]
    end
    
    def to_js

      %{
        <script type="text/javascript">
          google.load('visualization', '1', {'packages':['barchart']});
          google.setOnLoadCallback(drawChart);
          function drawChart() {
            var data = new google.visualization.DataTable();
#{data_columns(x_axis_label, y_axis_label)}
#{data_table}
            var options = {};
#{options}
            var container = document.getElementById('chart');
            var chart = new google.visualization.BarChart(container);
            chart.draw(data, options);
          }
        </script>
      }
    end
      
    # ====================================== Class Methods =========================================
    
    def self.render(data, args)
      graph = Seer::BarChart.new(
        :label_method   => args[:label_method],
        :x_axis_label   => args[:x_axis][:label],
        :x_axis_method  => args[:x_axis][:method],
        :y_axis_label   => args[:y_axis][:label],
        :y_axis_method  => args[:y_axis][:method],
        :chart_options  => args[:chart_options]
      )
      graph.data_table = data
      graph.to_js
    end
    
  end  

end
