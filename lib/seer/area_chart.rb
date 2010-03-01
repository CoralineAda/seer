module Seer

  # =USAGE
  # 
  # In your controller:
  #
  #   @data = Widgets.all # Must be an array, and must respond
  #                       # to the data method specified below (in this example, 'quantity')
  #
  #   @series = @data.map{|w| w.widget_stats} # An array of arrays
  #
  # In your view:
  #
  #   <div id="chart"></div>
  #
  #   <%= Seer::visualize(
  #         @data, 
  #         :as => :area_chart,
  #         :in_element => 'chart',
  #         :series => {
  #           :series_label => 'name',
  #           :data_label => 'date',
  #           :data_method => 'quantity',
  #           :data_series => @series
  #         },
  #         :chart_options => { 
  #           :height => 300,
  #           :width => 300,
  #           :axis_font_size => 11,
  #           :colors => ['#7e7587','#990000','#009900'],
  #           :title => "Widget Quantities",
  #           :point_size => 5
  #         }
  #        )
  #    -%>
  #
  # For details on the chart options, see the Google API docs at 
  # http://code.google.com/apis/visualization/documentation/gallery/areachart.html
  #
  class AreaChart
  
    include Seer::Chart
    
    # Graph options
    attr_accessor :axis_color, :axis_background_color, :axis_font_size, :background_color, :border_color, :data_table, :enable_tooltip, :focus_border_color, :height, :is_stacked, :legend, :legend_background_color, :legend_font_size, :legend_text_color, :line_size, :log_scale, :max, :min, :point_size, :reverse_axis, :show_categories, :title, :title_x, :title_y, :title_color, :title_font_size, :tooltip_font_size, :tooltip_height, :number, :tooltip_width, :width
    
    # Graph data
    attr_accessor :series_label, :data_label, :data, :data_method, :data_series
    
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

      @data_table = []
      
    end
  
    def data_columns #:nodoc:
      _data_columns =  "            data.addRows(#{data_rows.size});\r"
      _data_columns << "            data.addColumn('string', 'Date');\r"
      data.each do |datum|
        _data_columns << "            data.addColumn('number', '#{datum.send(series_label)}');\r"
      end
      _data_columns
    end
    
    def data_table #:nodoc:
      _rows = data_rows
      _rows.each_with_index do |r,i|
        @data_table << "            data.setCell(#{i}, 0,'#{r}');\r"
      end
      data_series.each_with_index do |column,i|
        column.each_with_index do |c,j|
          @data_table << "            data.setCell(#{j},#{i+1},#{c.send(data_method)});\r"
        end
      end
      @data_table
    end
    
    def data_rows
      data_series.inject([]) do |rows, element|
        rows |= element.map { |e| e.send(data_label) }
      end
    end

    def nonstring_options #:nodoc:
      [ :axis_font_size, :colors, :enable_tooltip, :height, :is_stacked, :legend_font_size, :line_size, :log_scale, :max, :min, :point_size, :reverse_axis, :show_categories, :title_font_size, :tooltip_font_size, :tooltip_height, :tooltip_width, :width]
    end
    
    def string_options #:nodoc:
      [ :axis_color, :axis_background_color, :background_color, :border_color, :focus_border_color, :legend, :legend_background_color, :legend_text_color, :title, :title_x, :title_y, :title_color ]
    end
    
    def to_js #:nodoc:

      %{
        <script type="text/javascript">
          google.load('visualization', '1', {'packages':['areachart']});
          google.setOnLoadCallback(drawChart);
          function drawChart() {
            var data = new google.visualization.DataTable();
#{data_columns}
#{data_table.to_s}
            var options = {};
#{options}
            var container = document.getElementById('#{self.chart_element}');
            var chart = new google.visualization.AreaChart(container);
            chart.draw(data, options);
          }
        </script>
      }
    end
      
    def self.render(data, args) #:nodoc:
      graph = Seer::AreaChart.new(
        :data => data,
        :series_label   => args[:series][:series_label],
        :data_series    => args[:series][:data_series],
        :data_label     => args[:series][:data_label],
        :data_method    => args[:series][:data_method],
        :chart_options  => args[:chart_options],
        :chart_element  => args[:in_element] || 'chart'
      )
      graph.to_js
    end
    
  end  

end
