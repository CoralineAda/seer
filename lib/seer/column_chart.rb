module Seer

  # =USAGE
  # 
  # In your controller:
  #
  #   @data = Widgets.all # Must be an array, and must respond
  #                       # to the data method specified below (in this example, 'quantity')
  #
  # In your view:
  #
  #   <div id="chart"></div>
  #
  #   <%= Seer::visualize(
  #         @widgets, 
  #         :as => :column_chart,
  #         :in_element => 'chart',
  #         :series => {:series_label => 'name', :data_method => 'quantity'},
  #         :chart_options => {
  #           :height   => 300,
  #           :width    => 300,
  #           :is_3_d   => true,
  #           :legend   => 'none',
  #           :colors   => "[{color:'#990000', darker:'#660000'}]",
  #           :title    => "Widget Quantities",
  #           :title_x  => 'Widgets',
  #           :title_y  => 'Quantities'
  #         }
  #       )
  #    -%>
  #   
  # Colors are treated differently for 2d and 3d graphs. If you set is_3_d to false, set the
  # graph color like this:
  #
  #           :colors   => "#990000"
  #
  # For details on the chart options, see the Google API docs at 
  # http://code.google.com/apis/visualization/documentation/gallery/columnchart.html
  #
  class ColumnChart
  
    include Seer::Chart
    
    # Chart options accessors
    attr_accessor :axis_color, :axis_background_color, :axis_font_size, :background_color, :border_color, :enable_tooltip, :focus_border_color, :height, :is_3_d, :is_stacked, :legend, :legend_background_color, :legend_font_size, :legend_text_color, :log_scale, :max, :min, :reverse_axis, :show_categories, :title, :title_x, :title_y, :title_color, :title_font_size, :tooltip_font_size, :tooltip_height, :tooltip_width, :width
    
    # Graph data
    attr_accessor :data, :data_method, :data_table, :label_method
    
    def initialize(args={}) #:nodoc:

      # Standard options
      args.each{ |method,arg| self.send("#{method}=",arg) if self.respond_to?(method) }

      # Chart options
      args[:chart_options].each{ |method, arg| self.send("#{method}=",arg) if self.respond_to?(method) }

      # Handle defaults      
      @colors ||= args[:chart_options][:colors] || DEFAULT_COLORS
      @legend ||= args[:chart_options][:legend] || DEFAULT_LEGEND_LOCATION
      @height ||= args[:chart_options][:height] || DEFAULT_HEIGHT
      @width  ||= args[:chart_options][:width] || DEFAULT_WIDTH
      @is_3_d ||= args[:chart_options][:is_3_d]

      @data_table = []
      
    end
  
    def data_table #:nodoc:
      data.each_with_index do |datum, column|
        @data_table << [
          "            data.setValue(#{column}, 0,'#{datum.send(label_method)}');\r",
          "            data.setValue(#{column}, 1, #{datum.send(data_method)});\r"
        ]
      end
      @data_table
    end

    def is_3_d #:nodoc:
      @is_3_d.blank? ? false : @is_3_d
    end
    
    def nonstring_options #:nodoc:
      [:axis_font_size, :colors, :enable_tooltip, :height, :is_3_d, :is_stacked, :legend_font_size, :log_scale, :max, :min, :reverse_axis, :show_categories, :title_font_size, :tooltip_font_size, :tooltip_width, :width]
    end
    
    def string_options #:nodoc:
      [:axis_color, :axis_background_color, :background_color, :border_color, :focus_border_color, :legend, :legend_background_color, :legend_text_color, :title, :title_x, :title_y, :title_color]
    end
    
    def to_js #:nodoc:

      %{
        <script type="text/javascript">
          google.load('visualization', '1', {'packages':['columnchart']});
          google.setOnLoadCallback(drawChart);
          function drawChart() {
            var data = new google.visualization.DataTable();
#{data_columns}
#{data_table.to_s}
            var options = {};
#{options}
            var container = document.getElementById('#{self.chart_element}');
            var chart = new google.visualization.ColumnChart(container);
            chart.draw(data, options);
          }
        </script>
      }
    end
      
    def self.render(data, args) #:nodoc:
      graph = Seer::ColumnChart.new(
        :data           => data,
        :label_method   => args[:series][:series_label],
        :data_method    => args[:series][:data_method],
        :chart_options  => args[:chart_options],
        :chart_element  => args[:in_element] || 'chart'
      )
      graph.to_js
    end
    
  end  

end
