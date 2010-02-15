module Seer

  # OrgChart creates a hierarchical diagram of parent and child nodes. Note that each node may only
  # display one parent.
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
  class OrgChart
  
    attr_accessor :foo
    
    def initialize(args={})
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
