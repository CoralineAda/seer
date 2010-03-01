require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Seer::Gauge" do

  before :each do
    @chart = Seer::Gauge.new(
        :data => [0,1,2,3],
        :label_method   => 'to_s',
        :data_method => 'size',
        :chart_options  => {},
        :chart_element  => 'chart'
     )
  end
  
  describe 'defaults' do
  
    it 'height' do
      @chart.height.should == Seer::Chart::DEFAULT_HEIGHT
    end
    
    it 'width' do
      @chart.width.should == Seer::Chart::DEFAULT_WIDTH
    end
    
  end

  describe 'graph options' do
  
    [:green_from, :green_to, :height, :major_ticks, :max, :min, :minor_ticks, :red_from, :red_to, :width, :yellow_from, :yellow_to].each do |accessor|
      it "sets its #{accessor} value" do
        @chart.send("#{accessor}=", 'foo')
        @chart.send(accessor).should == 'foo'
      end
    end
    
      it_should_behave_like 'it has colors attribute'
  end
  
  it 'renders as JavaScript' do
    (@chart.to_js =~ /javascript/).should be_true
    (@chart.to_js =~ /gauge/).should be_true
  end
  
  it 'sets its data columns' do
    @chart.data_columns.should =~ /addRows\(4\)/
  end
  
  it 'sets its data table' do
    @chart.data_table.to_s.should set_value(0, 0,'0')
    @chart.data_table.to_s.should set_value(0, 1, 8)
    @chart.data_table.to_s.should set_value(1, 0,'1')
    @chart.data_table.to_s.should set_value(1, 1, 8)
    @chart.data_table.to_s.should set_value(2, 0,'2')
    @chart.data_table.to_s.should set_value(2, 1, 8)
    @chart.data_table.to_s.should set_value(3, 0,'3')
    @chart.data_table.to_s.should set_value(3, 1, 8)
  end
  
end
