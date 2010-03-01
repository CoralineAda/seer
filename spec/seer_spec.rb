require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Seer" do

  require 'rubygems'
  
  it 'validates hexadecimal numbers' do
    invalid = [nil, '', 'food', 'bdadce', 123456]
    valid = ['#000000','#ffffff']
    invalid.each{ |e| Seer.valid_hex_number?(e).should be_false }
    valid.each  { |e| Seer.valid_hex_number?(e).should be_true }
  end

  describe 'visualize' do
  
    it 'raises an error for invalid visualizaters' do
      invalid = [:random, 'something']
      invalid.each do |e|
        lambda do
          Seer.visualize([1,2,3], :as => e)
        end.should raise_error(ArgumentError)
      end
    end
    
    it 'raises an error for missing data' do
      _data = []  
      lambda do
        Seer.visualize(_data, :as => :bar_chart)
      end.should raise_error(ArgumentError)
    end
    
    it 'accepts valid visualizers' do
      Seer::VISUALIZERS.each do |v|
        lambda do
          Seer::visualize(
            [0,1,2,3],
            :as => v,
            :in_element => 'chart',
            :series => {:label => 'to_s', :data => 'size'},
            :chart_options => {}
          )
        end.should_not raise_error(ArgumentError)
      end
    end

  end
  
  describe 'private chart methods' do
  
    it 'renders an area chart' do
      (Seer.send(:area_chart, 
        [0,1,2,3],
        :as => :area_chart,
        :in_element => 'chart',
        :series => {
          :series_label => 'to_s',
          :data_label => 'to_s',
          :data_method => 'size',
          :data_series => [[1,2,3],[3,4,5]]
        },
        :chart_options => {}
      ) =~ /areachart/).should be_true
    end

    it 'renders a bar chart' do
      (Seer.send(:bar_chart, 
        [0,1,2,3],
        :as => :bar_chart,
        :in_element => 'chart',
        :series => {
          :series_label => 'to_s',
          :data_method => 'size'
        },
        :chart_options => {}
      ) =~ /barchart/).should be_true
    end
    
    it 'renders a column chart' do
      (Seer.send(:column_chart, 
        [0,1,2,3],
        :as => :column_chart,
        :in_element => 'chart',
        :series => {
          :series_label => 'to_s',
          :data_method => 'size'
        },
        :chart_options => {}
      ) =~ /columnchart/).should be_true
    end
    
    it 'renders a gauge' do
      (Seer.send(:gauge, 
        [0,1,2,3],
        :as => :gauge,
        :in_element => 'chart',
        :series => {
          :series_label => 'to_s',
          :data_method => 'size'
        },
        :chart_options => {}
      ) =~ /gauge/).should be_true
    end
    
    it 'renders a line chart' do
      (Seer.send(:line_chart, 
        [0,1,2,3],
        :as => :line_chart,
        :in_element => 'chart',
        :series => {
          :series_label => 'to_s',
          :data_label => 'to_s',
          :data_method => 'size',
          :data_series => [[1,2,3],[3,4,5]]
        },
        :chart_options => {}
      ) =~ /linechart/).inspect #should be_true
    end

    it 'renders a pie chart' do
      (Seer.send(:pie_chart, 
        [0,1,2,3],
        :as => :pie_chart,
        :in_element => 'chart',
        :series => {
          :series_label => 'to_s',
          :data_method => 'size'
        },
        :chart_options => {}
      ) =~ /piechart/).should be_true
    end

  end
  
end
