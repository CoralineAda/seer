require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Seer::Chart" do

  before :all do
    @chart = Seer::AreaChart.new(
        :data => [0,1,2,3],
        :series_label   => 'to_s',
        :data_series => [[1,2,3],[3,4,5]],
        :data_label => 'to_s',
        :data_method => 'size',
        :chart_options  => { 
          :legend => 'right',
          :title_x => 'Something'
        },
        :chart_element  => 'chart'
     )
  end
  
  it 'sets the chart element' do
    @chart.in_element = 'foo'
    @chart.chart_element.should == 'foo'
  end
  
  describe 'sets colors' do
  
    it 'accepting valid values' do
      @chart.colors = ["#ff0000", "#00ff00"]
      @chart.colors.should == ["#ff0000", "#00ff00"]
    end
    
    it 'raising an error on invalid values' do
      lambda do
        @chart.colors = 'fred'
      end.should raise_error(ArgumentError)
      lambda do
        @chart.colors = [0,1,2]
      end.should raise_error(ArgumentError)
    end
    
  end
 
  it 'formats colors' do
    @chart.colors = ["#ff0000"]
    @chart.formatted_colors.should == "['ff0000']"
  end
  
  it 'sets its data columns' do
    @chart.data_columns.should =~ /addRows\(5\)/
    @chart.data_columns.should =~ /addColumn\('string', 'Date'\)/
    @chart.data_columns.should =~ /addColumn\('number', '0'\)/
    @chart.data_columns.should =~ /addColumn\('number', '1'\)/
    @chart.data_columns.should =~ /addColumn\('number', '2'\)/
    @chart.data_columns.should =~ /addColumn\('number', '3'\)/
  end
  
  it 'sets its options' do
    @chart.options.should =~ /options\['titleX'\] = 'Something'/
  end
  
  
end
