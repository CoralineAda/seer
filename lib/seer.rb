module Seer

  VISUALIZERS = [:area_chart, :bar_chart, :column_chart, :gauge, :line_chart, :pie_chart]
  
  def self.valid_hex_number?(val) #:nodoc:
    ! (val =~ /^\#([0-9]|[a-f]|[A-F])+$/).nil? && val.length == 7
  end

  def self.log(message) #:nodoc:
    RAILS_DEFAULT_LOGGER.info(message)
  end

  def self.init_visualization
    %{<script type="text/javascript" src="http://www.google.com/jsapi"></script>      }
  end
  
  def self.visualize(data, args={})
    raise ArgumentError, "Invalid visualizer: #{args[:as]}" unless args[:as] && VISUALIZERS.include?(args[:as])
    self.send(args[:as], data, args)
  end

  private
  
  def self.area_chart(data, args)
    AreaChart.render(data, args)
  end
  
  def self.bar_chart(data, args)
    BarChart.render(data, args)
  end
  
  def self.column_chart(data, args)
    ColumnChart.render(data, args)
  end
  
  def self.gauge(data, args)
    Gauge.render(data, args)
  end

  def self.line_chart(data, args)
    LineChart.render(data, args)
  end

  def self.pie_chart(data, args)
    PieChart.render(data, args)
  end
  
end
