module Seer

  # For details on the chart options, see the Google API docs at 
  # http://code.google.com/apis/visualization/documentation/gallery/linechart.html
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
  #           :is_3d => true,
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
  class LineChart
  
    include Seer::Chart
    
    # Graph options
    attr_accessor :axis_color, :axis_background_color, :axis_font_size, :background_color, :border_color, :colors, :data_table, :enable_tooltip, :focus_border_color, :height, :legend, :legend_background_color, :legend_font_size, :legend_text_color, :line_size, :log_scale, :max, :min, :point_size, :reverse_axis, :show_categories, :smooth_line, :title, :title_x, :title_y, :title_color, :title_font_size, :tooltip_font_size, :tooltip_height, :number, :tooltip_width, :width
    
    # Graph data
    attr_accessor :series_label, :data_label, :data, :data_method, :data_series
    
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

      @data_table = []
      
    end
  
    def data_columns
      _data_columns =  "            data.addRows(#{data_series.first.map{|d| d.send(data_label)}.uniq.size});\r"
      _data_columns << "            data.addColumn('string', 'Date');\r"
      data.each do |datum|
        _data_columns << "            data.addColumn('number', '#{datum.send(series_label)}');\r"
      end
      _data_columns
    end
    
    def data_table=(data)
      _rows = data_series.first.map{|d| d.send(data_label)}.uniq
      _rows.each_with_index do |r,i|
        @data_table << "            data.setCell(#{i}, 0,'#{r}');\r"
      end
      data_series.each_with_index do |column,i|
        column.each_with_index do |c,j|
          @data_table << "data.setCell(#{j},#{i+1},#{c.send(data_method)});\r"
        end
      end
    end

    def nonstring_options
      [ :axis_font_size, :colors, :enable_tooltip, :height, :legend_font_size, :line_size, :log_scale, :max, :min, :point_size, :reverse_axis, :show_categories, :smooth_line, :title_font_size, :tooltip_font_size, :tooltip_height, :tooltip_width, :width]
    end
    
    def string_options
      [ :axis_color, :axis_background_color, :background_color, :border_color, :focus_border_color, :legend, :legend_background_color, :legend_text_color, :title, :title_x, :title_y, :title_color ]
    end
    
    def to_js(data)

      %{
        <script type="text/javascript">
          google.load('visualization', '1', {'packages':['linechart']});
          google.setOnLoadCallback(drawChart);
          function drawChart() {
            var data = new google.visualization.DataTable();
#{data_columns}
#{data_table}
            var options = {};
#{options}
            var container = document.getElementById('chart');
            var chart = new google.visualization.LineChart(container);
            chart.draw(data, options);
          }
        </script>
      }
    end
      
    # ====================================== Class Methods =========================================
    
    def self.render(data, args)
      graph = Seer::LineChart.new(
        :data => data,
        :series_label   => args[:series][:series_label],
        :data_series    => args[:series][:data_series],
        :data_label     => args[:series][:data_label],
        :data_method    => args[:series][:data_method],
        :chart_options  => args[:chart_options]
      )
      graph.data_table = data
      graph.to_js(data)
    end
    
  end  

end
