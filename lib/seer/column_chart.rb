module Seer

  # For details on the chart options, see the Google API docs at 
  # http://code.google.com/apis/visualization/documentation/gallery/columnchart.html
  #
  # =USAGE=
  # 
  # In your view:
  #
  #   <div id="chart" class="chart"></div>
  #
  #   <%= visualize(
  #         @widgets, 
  #         :as => :column_chart,
  #         :series => {:label => 'name', :data => 'quantity'},
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
  
  class ColumnChart
  
    include Seer::Chart
    
    # Chart options accessors
    attr_accessor :axis_color, :axis_background_color, :axis_font_size, :background_color, :border_color, :colors, :data_table, :enable_tooltip, :focus_border_color, :height, :is_3_d, :is_stacked, :legend, :legend_background_color, :legend_font_size, :legend_text_color, :log_scale, :max, :min, :reverse_axis, :show_categories, :title, :title_x, :title_y, :title_color, :title_font_size, :tooltip_font_size, :tooltip_height, :tooltip_width, :width
    
    # Graph data
    attr_accessor :label_method, :data_method
    
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
          "            data.setValue(#{column}, 1, #{datum.send(data_method)});\r"
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
          google.load('visualization', '1', {'packages':['columnchart']});
          google.setOnLoadCallback(drawChart);
          function drawChart() {
            var data = new google.visualization.DataTable();
#{data_columns(label_method, data_method)}
#{data_table}
            var options = {};
#{options}
            var container = document.getElementById('chart');
            var chart = new google.visualization.ColumnChart(container);
            chart.draw(data, options);
          }
        </script>
      }
    end
      
    def self.render(data, args)
      graph = Seer::ColumnChart.new(
        :label_method   => args[:series][:label],
        :data_method    => args[:series][:data],
        :chart_options  => args[:chart_options]
      )
      graph.data_table = data
      graph.to_js
    end
    
  end  

end
