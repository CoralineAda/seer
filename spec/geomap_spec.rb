require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Seer::Geomap" do

  before :each do

    class GeoThing
      def initialize; end
      def name; 'foo'; end
      def latitude; -90; end
      def longitude; -90; end
      def count; 8; end
      def geocoded?; true; end
    end
  
    @chart = Seer::Geomap.new(
        :data => [GeoThing.new, GeoThing.new, GeoThing.new],
        :label_method   => 'name',
        :data_method => 'count',
        :chart_options  => {},
        :chart_element  => 'geochart'
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
  
    [:show_zoom_out, :zoom_out_label].each do |accessor|
      it "sets its #{accessor} value" do
        @chart.send("#{accessor}=", 'foo')
        @chart.send(accessor).should == 'foo'
      end
    end
    
      it_should_behave_like 'it has colors attribute'
  end
  
  it 'renders as JavaScript' do
    (@chart.to_js =~ /javascript/).should be_true
    (@chart.to_js =~ /geomap/).should be_true
  end
  
  it 'sets its data columns' do
    @chart.data_columns.should =~ /addRows\(3\)/
  end
  
  it 'sets its data table' do
    @chart.data_table.to_s.should set_value(0, 0,'foo')
    @chart.data_table.to_s.should set_value(0, 1, 8)
    @chart.data_table.to_s.should set_value(1, 0,'foo')
    @chart.data_table.to_s.should set_value(1, 1, 8)
    @chart.data_table.to_s.should set_value(2, 0,'foo')
    @chart.data_table.to_s.should set_value(2, 1, 8)
  end

end
