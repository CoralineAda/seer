module Seer

  require 'seer/chart'
  require 'seer/area_chart'
  require 'seer/bar_chart'
  require 'seer/column_chart'
  require 'seer/gauge'
  require 'seer/line_chart'
  require 'seer/pie_chart'
  
  VISUALIZERS = [:area_chart, :bar_chart, :column_chart, :gauge, :line_chart, :pie_chart]
  
  def self.valid_hex_number?(val) #:nodoc:
    return false unless val.is_a?(String) && ! val.empty?
    ! (val =~ /^\#([0-9]|[a-f]|[A-F])+$/).nil? && val.length == 7
  end

  def self.log(message) #:nodoc:
    RAILS_DEFAULT_LOGGER.info(message)
  end

  def self.init_visualization
    %{
    <script type="text/javascript">
      var jsapi = (("https:" == document.location.protocol) ? "https://" : "http://");
      document.write(unescape("%3Cscript src='" + jsapi + "www.google.com/jsapi' type='text/javascript'%3E%3C/script%3E"));
    </script>
    }
  end
  
  def self.visualize(data, args={})
    raise ArgumentError, "Seer: Invalid visualizer: #{args[:as]}" unless args[:as] && VISUALIZERS.include?(args[:as])
    raise ArgumentError, "Seer: No data provided!" unless data && ! data.empty?
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
