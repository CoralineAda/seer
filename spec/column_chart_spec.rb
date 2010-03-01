require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Seer::ColumnChart" do

  before :each do
    @chart = Seer::ColumnChart.new(
      :data => [0,1,2,3],
      :label_method   => 'to_s',
      :data_method => 'size',
      :chart_options  => {},
      :chart_element  => 'chart'
     )
  end
  
  describe 'defaults' do  
    it_should_behave_like 'it sets default values'
  end

  describe 'graph options' do
  
    [:axis_color, :axis_background_color, :axis_font_size, :background_color, :border_color, :enable_tooltip, :focus_border_color, :height, :is_3_d, :is_stacked, :legend, :legend_background_color, :legend_font_size, :legend_text_color, :log_scale, :max, :min, :reverse_axis, :show_categories, :title, :title_x, :title_y, :title_color, :title_font_size, :tooltip_font_size, :tooltip_height, :tooltip_width, :width].each do |accessor|
      it "sets its #{accessor} value" do
        @chart.send("#{accessor}=", 'foo')
        @chart.send(accessor).should == 'foo'
      end
    end
    
    it_should_behave_like 'it has colors attribute'   
  end
  
  it 'renders as JavaScript' do
    (@chart.to_js =~ /javascript/).should be_true
    (@chart.to_js =~ /columnchart/).should be_true
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
