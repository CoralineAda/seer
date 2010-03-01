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
  #         @data, 
  #         :as => :gauge,
  #         :in_element => 'chart',
  #         :series => {:series_label => 'name', :data_method => 'quantity'},
  #         :chart_options => {
  #           :green_from => 0,
  #           :green_to => 50,
  #           :height => 300,
  #           :max => 100,
  #           :min => 0,
  #           :minor_ticks => 5,
  #           :red_from => 76,
  #           :red_to => 100,
  #           :width => 600,
  #           :yellow_from => 51,
  #           :yellow_to => 75
  #         }
  #       )
  #    -%>
  #
  # For details on the chart options, see the Google API docs at 
  # http://code.google.com/apis/visualization/documentation/gallery/gauge.html
  #
  class Gauge
  
    include Seer::Chart
    
    # Chart options accessors
    attr_accessor :green_from, :green_to, :height, :major_ticks, :max, :min, :minor_ticks, :red_from, :red_to, :width, :yellow_from, :yellow_to
    
    # Graph data
    attr_accessor :data, :data_method, :data_table, :label_method
    
    def initialize(args={})  #:nodoc:

      # Standard options
      args.each{ |method,arg| self.send("#{method}=",arg) if self.respond_to?(method) }

      # Chart options
      args[:chart_options].each{ |method, arg| self.send("#{method}=",arg) if self.respond_to?(method) }

      # Handle defaults      
      @height ||= args[:chart_options][:height] || DEFAULT_HEIGHT
      @width  ||= args[:chart_options][:width] || DEFAULT_WIDTH

      @data_table = []
      
    end
  
    def data_table  #:nodoc:
      data.each_with_index do |datum, column|
        @data_table << [
          "            data.setValue(#{column}, 0,'#{datum.send(label_method)}');\r",
          "            data.setValue(#{column}, 1, #{datum.send(data_method)});\r"
        ]
      end
      @data_table
    end

    def is_3_d  #:nodoc:
      @is_3_d.blank? ? false : @is_3_d
    end
    
    def nonstring_options  #:nodoc:
      [:green_from, :green_to, :height, :major_ticks, :max, :min, :minor_ticks, :red_from, :red_to, :width, :yellow_from, :yellow_to]
    end
    
    def string_options  #:nodoc:
      []
    end
    
    def to_js  #:nodoc:

      %{
        <script type="text/javascript">
          google.load('visualization', '1', {'packages':['gauge']});
          google.setOnLoadCallback(drawChart);
          function drawChart() {
            var data = new google.visualization.DataTable();
#{data_columns}
#{data_table.join}
            var options = {};
#{options}
            var container = document.getElementById('#{self.chart_element}');
            var chart = new google.visualization.Gauge(container);
            chart.draw(data, options);
          }
        </script>
      }
    end
      
    def self.render(data, args)  #:nodoc:
      graph = Seer::Gauge.new(
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
