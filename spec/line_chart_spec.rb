require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Seer::LineChart" do

  before :each do
    @chart = Seer::LineChart.new(
        :data => [0,1,2,3],
        :series_label   => 'to_s',
        :data_series => [[1,2,3],[3,4,5]],
        :data_label => 'to_s',
        :data_method => 'size',
        :chart_options  => {},
        :chart_element  => 'chart'
     )
  end
  
  describe 'defaults' do  
    it_should_behave_like 'it sets default values'
  end

  describe 'graph options' do
  
    [:axis_color, :axis_background_color, :axis_font_size, :background_color, :border_color, :enable_tooltip, :focus_border_color, :height, :legend, :legend_background_color, :legend_font_size, :legend_text_color, :line_size, :log_scale, :max, :min, :point_size, :reverse_axis, :show_categories, :smooth_line, :title, :title_x, :title_y, :title_color, :title_font_size, :tooltip_font_size, :tooltip_height, :number, :tooltip_width, :width].each do |accessor|
      it "sets its #{accessor} value" do
        @chart.send("#{accessor}=", 'foo')
        @chart.send(accessor).should == 'foo'
      end
    end
    
    it_should_behave_like 'it has colors attribute'
  end
  
  it 'renders as JavaScript' do
    (@chart.to_js =~ /javascript/).should be_true
    (@chart.to_js =~ /linechart/).should be_true
  end
  
  it 'sets its data columns' do
    @chart.data_columns.should =~ /addRows\(5\)/
    @chart.data_columns.should add_column('string', 'Date')
    @chart.data_columns.should add_column('number', '0')
    @chart.data_columns.should add_column('number', '1')
    @chart.data_columns.should add_column('number', '2')
    @chart.data_columns.should add_column('number', '3')
  end
  
  it 'sets its data table' do
    @chart.data_table.to_s.should set_cell(0, 0,'1')
    @chart.data_table.to_s.should set_cell(1, 0,'2')
    @chart.data_table.to_s.should set_cell(2, 0,'3')
    @chart.data_table.to_s.should set_cell(3, 0,'4')
    @chart.data_table.to_s.should set_cell(4, 0,'5')
    @chart.data_table.to_s.should set_cell(0,1,8)
    @chart.data_table.to_s.should set_cell(2,1,8)
    @chart.data_table.to_s.should set_cell(0,2,8)
    @chart.data_table.to_s.should set_cell(1,2,8)
    @chart.data_table.to_s.should set_cell(2,2,8)
  end
  
  describe 'when data_series is an array of arrays of arrays/hashes' do
    before(:each) do 
      data_series = Array.new(3) {|i| [[i, i+1], [i+1, i+2]]}
      @chart = Seer::LineChart.new(
          :data => [0,1,2,3],
          :series_label   => 'to_s',
          :data_series => data_series,
          :data_label => 'first',
          :data_method => 'size',
          :chart_options  => {},
          :chart_element  => 'chart'
       )
     end

    it 'calculates number of rows' do
      @chart.data_columns.should =~ /addRows\(4\)/     
    end
    
    it 'sets its data table' do 
      @chart.data_table.to_s.should set_cell(0, 0,'0')
      @chart.data_table.to_s.should set_cell(1, 0,'1')
      @chart.data_table.to_s.should set_cell(2, 0,'2')
      @chart.data_table.to_s.should set_cell(3, 0,'3')
    end
  end
  
end
