module Seer

  # Geomap creates a map of a country, continent, or region, with colors and values assigned to
  # specific regions. Values are displayed as a color scale, and you can specify optional hovertext 
  # for regions.
  #
  # =USAGE=
  # 
  # In your view:
  #
  #   <%= visualize(@widgets, :as => :geomap, :data_mode => 'regions', :region => 'US',
  #         :label_method => 'name',
  #         :values => [ { :label => '# Deliveries', :method => 'deliveries_count' } ]
  #       )
  #   -%>
  #
  #   <div id="chart" class="chart"></div>
  #
  # ==@objects==
  #
  # A collection of objects (ActiveRecord or otherwise) that must respond to the
  # following methods:
  #
  #   latitude  # => returns the latitude in decimal format
  #   longitude # => returns the longitude in decimal format
  #   geocoded? # => result of latitude && longitude
  #
  # ==:as==
  # Indicates the type of visualization, in this case a geomap.
  #
  # ==:data_mode==
  # May be 'regions' (default) for displaying highlighted regions, or 'markers' for displaying 
  # color- and size-coded markers for data values superimposed on a map.
  #
  # ==:region==
  # Specifies the map that should be displayed. Pass in 'world' for a world map, 'US' for a 
  # United States-only map, or use a two-digit ISO country code (defined in COUNTRY_CODES below)
  # to specify another location.
  #
  # ==:label_method==
  # In the example usage above, the metric is 'widget'. The :label_method you provide will generate
  # the hover label by calling this method on all instances of the metric. For example, in the
  # usage sample above, mousing over a region (or marker) would display a popup that reads 
  # 
  #   <object name>
  #   # Deliveries: 13
  #
  # ==:values==
  # Values is an array of data values to chart. For the geomap visualization, the array contains a
  # single hash consisting of a data label (# Deliveries) and a method to invoke on the metric 
  # object to obtain the value (e.g. widget.deliveries_count)
  #
  class Geomap
  
    COUNTRY_CODES = ['world', 'AX', 'AF', 'AL', 'DZ', 'AS', 'AD', 'AO', 'AI', 'AQ', 'AG', 'AR', 'AM', 'AW', 'AU', 'AT', 'AZ', 'BS', 'BH', 'BD', 'BB', 'BY', 'BE', 'BZ', 'BJ', 'BM', 'BT', 'BO', 'BA', 'BW', 'BV', 'BR', 'IO', 'BN', 'BG', 'BF', 'BI', 'KH', 'CM', 'CA', 'CV', 'KY', 'CF', 'TD', 'CL', 'CN', 'CX', 'CC', 'CO', 'KM', 'CD', 'CG', 'CK', 'CR', 'CI', 'HR', 'CU', 'CY', 'CZ', 'DK', 'DJ', 'DM', 'DO', 'EC', 'EG', 'SV', 'GQ', 'ER', 'EE', 'ET', 'FK', 'FO', 'FJ', 'FI', 'FR', 'GF', 'PF', 'TF', 'GA', 'GM', 'GE', 'DE', 'GH', 'GI', 'GR', 'GL', 'GD', 'GP', 'GU', 'GT', 'GN', 'GW', 'GY', 'HT', 'HM', 'HN', 'HK', 'HU', 'IS', 'IN', 'ID', 'IR', 'IQ', 'IE', 'IL', 'IT', 'JM', 'JP', 'JO', 'KZ', 'KE', 'KI', 'KP', 'KR', 'KW', 'KG', 'LA', 'LV', 'LB', 'LS', 'LR', 'LY', 'LI', 'LT', 'LU', 'MO', 'MK', 'MG', 'MW', 'MY', 'MV', 'ML', 'MT', 'MH', 'MQ', 'MR', 'MU', 'YT', 'MX', 'FM', 'MD', 'MC', 'MN', 'MS', 'MA', 'MZ', 'MM', 'NA', 'NR', 'NP', 'NL', 'AN', 'NC', 'NZ', 'NI', 'NE', 'NG', 'NU', 'NF', 'MP', 'NO', 'OM', 'PK', 'PW', 'PS', 'PA', 'PG', 'PY', 'PE', 'PH', 'PN', 'PL', 'PT', 'PR', 'QA', 'RE', 'RO', 'RU', 'RW', 'SH', 'KN', 'LC', 'PM', 'VC', 'WS', 'SM', 'ST', 'SA', 'SN', 'CS', 'SC', 'SL', 'SG', 'SK', 'SI', 'SB', 'SO', 'ZA', 'GS', 'ES', 'LK', 'SD', 'SR', 'SJ', 'SZ', 'SE', 'CH', 'SY', 'TW', 'TJ', 'TZ', 'TH', 'TL', 'TG', 'TK', 'TO', 'TT', 'TN', 'TR', 'TM', 'TC', 'TV', 'UG', 'UA', 'AE', 'GB', 'US', 'UM', 'UY', 'UZ', 'VU', 'VA', 'VE', 'VN', 'VG', 'VI', 'WF', 'EH', 'YE', 'ZM', 'ZW', '005', '013', '021', '002', '017', '015', '018', '030', '034', '035', '143', '145', '151', '154', '155', '039']
  
    COLORS = ['#bec8be', '#919e4b']
    
    attr_accessor :colors, :data_mode, :data_table, :height, :region, :show_legend, :width, :value_object, :value_method, :value_label, :metric_method, :metric_label
    
    def initialize(args={})
      @colors = args[:colors] || COLORS
      @colors.flatten!
      @data_mode = args[:data_mode] || 'regions'
      @show_legend = true
      @height = args[:height] || '347px'
      @width = args[:width] || '556px'
      @data_table = args[:data_table] || []
      @region = args[:region] || 'world'
      @value_object = args[:value_object]
      @value_method = args[:value_method]
      @value_label = args[:value_label]
      @metric_method = args[:metric_method]
      @metric_label = args[:metric_label]
    end
  
    def colors=(colors_list)
      raise ArgumentError, "Invalid color option: #{colors_list}" unless colors_list.is_a?(Array) && colors_list.inject([]){|set,color| set << color if Seer.valid_hex_number?(color); set }.size == colors_list.size
      @colors = colors_list
    end
    
    def colors
      "[#{@colors.map{|color| "0x#{color.gsub(/\#/,'')}"} * ','}]"
    end
    
    def data_columns(object_label, value_label)
      _data_columns = "data.addRows(#{data_table.size});"
      if self.data_mode == 'markers'
        _data_columns << %{
          data.addColumn('number', 'LATITUDE');
          data.addColumn('number', 'LONGITUDE');
          data.addColumn('number', '#{value_label}');
          data.addColumn('string', '#{object_label}');
        }
      else
        _data_columns << %{    
          data.addColumn('string', '#{object_label}');
          data.addColumn('number', '#{value_label}');
        }
      end
      _data_columns
    end
    
    def data_mode=(mode)
      raise ArgumentError, "Invalid data mode option: #{mode}. Must be one of 'regions' or 'markers'." unless ['regions', 'markers'].include?(mode)
      @data_mode = mode
    end
    
    def data_table=(data)
      data.each_with_index do |datum, column|
        next unless datum.geocoded?
        if data_mode == "markers"
          @data_table << [
            "data.setValue(#{column}, 0, #{datum.latitude});",
            "data.setValue(#{column}, 1, #{datum.longitude});",
            "data.setValue(#{column}, 2, #{datum.send(value_method)});",
            "data.setValue(#{column}, 3, \"#{datum.send(metric_method)}\");",
          ]
        else # Regions
          @data_table << [
            "data.setValue(#{column}, 0, \"#{datum.name}\");",
            "data.setValue(#{column}, 1, #{datum.send(value_method)});\r"
          ]
        end
      end
    end
    
    def to_js
      %{
        <script type="text/javascript">
          google.load('visualization', '1', {'packages':['geomap']});
          google.setOnLoadCallback(drawChart);
          function drawChart() {
            var data = new google.visualization.DataTable();
            #{data_columns(metric_label, value_label)}
            #{data_table}
            var options = {};
            options['region'] = '#{region}';
            options['colors'] = #{colors};
            options['dataMode'] = '#{data_mode}';
            options['showLegend'] = #{show_legend};
            var container = document.getElementById('chart');
            var geomap = new google.visualization.GeoMap(container);
            geomap.draw(data, options);
          }
        </script>
      }
    end
    
    def height=(desired_height)
      if desired_height.is_a?(String) && desired_height =~ /^[0-9]+(px)*$/
        @height = desired_height.include?("px") ? desired_height : "#{desired_height}px"
      elsif desired_height.is_a?(Fixnum)
        @height = "#{desired_height.to_s}px"
      else
        raise ArgumentError, "Invalid height: #{desired_height}"
      end
    end
    
    def width=(desired_width)
      if desired_width.is_a?(String) && desired_width =~ /^[0-9]+(px)*$/
        @width = desired_width.include?("px") ? desired_width : "#{desired_width}px"
      elsif desired_width.is_a?(Fixnum)
        @width = "#{desired_width.to_s}px"
      else
        raise ArgumentError, "Invalid width: #{desired_width}"
      end
     end
  
    def region=(desired_region)
      raise ArgumentError, "Invalid region: #{desired_region}" unless COUNTRY_CODES.include?(desired_region)
      @region = desired_region
    end
  
    # ====================================== Class Methods =========================================
    
    def self.render(data, args)
      map = Seer::Geomap.new(
        :region => args[:region],
        :data_mode => args[:data_mode],
        :value_object => args[:values].first[:object],
        :value_label => args[:values].first[:label],
        :value_method => args[:values].first[:method],
        :metric_method => args[:label_method],
        :metric_label => args[:object_label]
      )
      map.data_table = data
      map.to_js
    end
    
  end  

end
