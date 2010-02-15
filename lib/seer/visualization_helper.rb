module Seer

  module VisualizationHelper
    
    VISUALIZERS = [:bar_chart, :column_chart, :geomap, :line_chart, :org_chart]
    
    def init_visualization
      %{<script type="text/javascript" src="http://www.google.com/jsapi"></script>      }
    end
    
    def visualize(data, args={})
      raise ArgumentError, "Invalid visualizer: #{args[:as]}" unless args[:as] && VISUALIZERS.include?(args[:as])
      self.send(args[:as], data, args)
    end
  
    private
    
    def bar_chart(data, args)
      BarChart.render(data, args)
    end
    
    def column_chart(data, args)
      ColumnChart.render(data, args)
    end
    
    def geomap(data, args)
      Geomap.render(data, args)
    end

    def line_chart(data, args)
      LineChart.render(data, args)
    end
      
    def org_chart(data, args)
      OrgChart.render(data, args)
    end
    
  end

end