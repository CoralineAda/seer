module Seer

  # Geomap creates a map of a country, continent, or region, with colors and values assigned to
  # specific regions. Values are displayed as a color scale, and you can specify optional hovertext 
  # for regions.
  #
  # =USAGE=
  # 
  # In your view:
  #
  #   <div id="my_geomap_container" class="chart"></div>
  #
  #   <%= Seer::visualize(
  #         @locations,
  #         :as => :geomap,
  #         :in_element => 'my_geomap_container',
  #         :series => {
  #           :series_label => 'name',
  #           :data_label => '# widgets',
  #           :data_method => 'widget_count'
  #         },
  #         :chart_options => {
  #           :data_mode => 'regions',
  #           :region => 'US',
  #         }  
  #       )
  #   -%>
  #
  # ==@locations==
  #
  # A collection of objects (ActiveRecord or otherwise) that must respond to the
  # following methods:
  #
  #   latitude  # => returns the latitude in decimal format
  #   longitude # => returns the longitude in decimal format
  #   geocoded? # => result of latitude && longitude
  #
  # For details on the chart options, see the Google API docs at 
  # http://code.google.com/apis/visualization/documentation/gallery/geomap.html
  #
  class Geomap
  
    include Seer::Chart

    COUNTRY_CODES = ['world', 'AX', 'AF', 'AL', 'DZ', 'AS', 'AD', 'AO', 'AI', 'AQ', 'AG', 'AR', 'AM', 'AW', 'AU', 'AT', 'AZ', 'BS', 'BH', 'BD', 'BB', 'BY', 'BE', 'BZ', 'BJ', 'BM', 'BT', 'BO', 'BA', 'BW', 'BV', 'BR', 'IO', 'BN', 'BG', 'BF', 'BI', 'KH', 'CM', 'CA', 'CV', 'KY', 'CF', 'TD', 'CL', 'CN', 'CX', 'CC', 'CO', 'KM', 'CD', 'CG', 'CK', 'CR', 'CI', 'HR', 'CU', 'CY', 'CZ', 'DK', 'DJ', 'DM', 'DO', 'EC', 'EG', 'SV', 'GQ', 'ER', 'EE', 'ET', 'FK', 'FO', 'FJ', 'FI', 'FR', 'GF', 'PF', 'TF', 'GA', 'GM', 'GE', 'DE', 'GH', 'GI', 'GR', 'GL', 'GD', 'GP', 'GU', 'GT', 'GN', 'GW', 'GY', 'HT', 'HM', 'HN', 'HK', 'HU', 'IS', 'IN', 'ID', 'IR', 'IQ', 'IE', 'IL', 'IT', 'JM', 'JP', 'JO', 'KZ', 'KE', 'KI', 'KP', 'KR', 'KW', 'KG', 'LA', 'LV', 'LB', 'LS', 'LR', 'LY', 'LI', 'LT', 'LU', 'MO', 'MK', 'MG', 'MW', 'MY', 'MV', 'ML', 'MT', 'MH', 'MQ', 'MR', 'MU', 'YT', 'MX', 'FM', 'MD', 'MC', 'MN', 'MS', 'MA', 'MZ', 'MM', 'NA', 'NR', 'NP', 'NL', 'AN', 'NC', 'NZ', 'NI', 'NE', 'NG', 'NU', 'NF', 'MP', 'NO', 'OM', 'PK', 'PW', 'PS', 'PA', 'PG', 'PY', 'PE', 'PH', 'PN', 'PL', 'PT', 'PR', 'QA', 'RE', 'RO', 'RU', 'RW', 'SH', 'KN', 'LC', 'PM', 'VC', 'WS', 'SM', 'ST', 'SA', 'SN', 'CS', 'SC', 'SL', 'SG', 'SK', 'SI', 'SB', 'SO', 'ZA', 'GS', 'ES', 'LK', 'SD', 'SR', 'SJ', 'SZ', 'SE', 'CH', 'SY', 'TW', 'TJ', 'TZ', 'TH', 'TL', 'TG', 'TK', 'TO', 'TT', 'TN', 'TR', 'TM', 'TC', 'TV', 'UG', 'UA', 'AE', 'GB', 'US', 'us_metro', 'UM', 'UY', 'UZ', 'VU', 'VA', 'VE', 'VN', 'VG', 'VI', 'WF', 'EH', 'YE', 'ZM', 'ZW', '005', '013', '021', '002', '017', '015', '018', '030', '034', '035', '143', '145', '151', '154', '155', '039']
  
    # Chart options accessors
    attr_accessor :data_mode, :enable_tooltip, :height, :legend_background_color, :legend_font_size, :legend_text_color, :legend, :region, :show_legend, :show_zoom_out, :title_color, :title_font_size, :title_x, :title_y, :title, :tooltip_font_size, :tooltip_height, :tooltip_width, :width, :zoom_out_label
    
    # Graph data
    attr_accessor :data, :data_label, :data_method, :data_table, :label_method
    
    def initialize(args={}) #:nodoc:
    
      # Standard options
      args.each{ |method,arg| self.send("#{method}=",arg) if self.respond_to?(method) }

      # Chart options
      args[:chart_options].each{ |method, arg| self.send("#{method}=",arg) if self.respond_to?(method) }

      # Handle defaults
      @colors ||= args[:chart_options][:colors] || DEFAULT_COLORS
      @legend ||= args[:chart_options][:legend] || DEFAULT_LEGEND_LOCATION
      @height ||= args[:chart_options][:height] || DEFAULT_HEIGHT
      @width  ||= args[:chart_options][:width]  || DEFAULT_WIDTH

    end
  
    def data_columns #:nodoc:
      _data_columns = "data.addRows(#{data_table.size});"
      if self.data_mode == 'markers'
        _data_columns << %{
          data.addColumn('number', 'LATITUDE');
          data.addColumn('number', 'LONGITUDE');
          data.addColumn('number', '#{data_method}');
          data.addColumn('string', '#{label_method}');
        }
      else
        _data_columns << "          data.addColumn('string', '#{label_method}');"
        _data_columns << "          data.addColumn('number', '#{data_method}');"
        _data_columns
      end
      _data_columns
    end
    
    def data_mode=(mode) #:nodoc:
      raise ArgumentError, "Invalid data mode option: #{mode}. Must be one of 'regions' or 'markers'." unless ['regions', 'markers'].include?(mode)
      @data_mode = mode
    end

    def data_table #:nodoc:
      @data_table = []
      data.select{ |d| d.geocoded? }.each_with_index do |datum, column|
        if data_mode == "markers"
          @data_table << [
            "            data.setValue(#{column}, 0, #{datum.latitude});\r",
            "            data.setValue(#{column}, 1, #{datum.longitude});\r",
            "            data.setValue(#{column}, 2, #{datum.send(data_method)});\r",
            "            data.setValue(#{column}, 3, '#{datum.send(label_method)}');\r"
          ]
        else # Regions
          @data_table << [
            "            data.setValue(#{column}, 0, '#{datum.name}');\r",
            "            data.setValue(#{column}, 1, #{datum.send(data_method)});\r"
          ]
        end
      end
      @data_table
    end
  
    # Because Google is not consistent in their @#!$ API...
    def formatted_colors
      "[#{@colors.map{|color| "'#{color.gsub(/\#/,'0x')}'"} * ','}]"
    end
    
    def nonstring_options  #:nodoc:
      [:colors, :enable_tooltip, :height, :legend_font_size, :title_font_size, :tooltip_font_size, :tooltip_width, :width]
    end
    
    def string_options #:nodoc:
      [:data_mode, :legend, :legend_background_color, :legend_text_color, :title, :title_x, :title_y, :title_color, :region]
    end
    
    def to_js
      %{
        <script type="text/javascript">
          google.load('visualization', '1', {'packages':['geomap']});
          google.setOnLoadCallback(drawChart);
          function drawChart() {
            var data = new google.visualization.DataTable();
#{data_columns}
#{data_table.join("\r")}
            var options = {};
#{options}
            var container = document.getElementById('#{self.chart_element}');
            var geomap = new google.visualization.GeoMap(container);
            geomap.draw(data, options);
          }
        </script>
      }
    end
    
    def region=(desired_region)
      raise ArgumentError, "Invalid region: #{desired_region}" unless COUNTRY_CODES.include?(desired_region)
      @region = desired_region
    end
  
    # ====================================== Class Methods =========================================
    
    def self.render(data, args)
      map = Seer::Geomap.new(
        :region         => args[:chart_options][:region],
        :data_mode      => args[:chart_options][:data_mode],
        :data           => data,
        :label_method   => args[:series][:series_label],
        :data_method    => args[:series][:data_method],
        :chart_options  => args[:chart_options],
        :chart_element  => args[:in_element] || 'chart'
      )
      map.to_js
    end
    
  end  

end
