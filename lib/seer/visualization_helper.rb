module Seer

  module VisualizationHelper #:nodoc:
    
    VISUALIZERS = [:area_chart, :bar_chart, :column_chart, :gauge, :line_chart, :pie_chart]
    
    def init_visualization
      %{<script type="text/javascript" src="http://www.google.com/jsapi"></script>      }
    end
    
    def visualize(data, args={})
      raise ArgumentError, "Invalid visualizer: #{args[:as]}" unless args[:as] && VISUALIZERS.include?(args[:as])
      self.send(args[:as], data, args)
    end
  
    private
    
    def area_chart(data, args)
      AreaChart.render(data, args)
    end
    
    def bar_chart(data, args)
      BarChart.render(data, args)
    end
    
    def column_chart(data, args)
      ColumnChart.render(data, args)
    end
    
    def gauge(data, args)
      Gauge.render(data, args)
    end

    def line_chart(data, args)
      LineChart.render(data, args)
    end

    def pie_chart(data, args)
      PieChart.render(data, args)
    end
    
  end

end