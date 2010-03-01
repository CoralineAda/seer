describe "it has colors attribute", :shared => true do   
  it 'sets its colors value' do
    color_list =  ['#7e7587','#990000','#009900', '#3e5643', '#660000', '#003300']  
    @chart.colors = color_list
    @chart.colors.should == color_list
  end
  
  it 'colors should be an array' do 
    lambda {
      @chart.colors = '#000000'
    }.should raise_error(ArgumentError)
  end

  it 'colors should be valid hex values' do 
    lambda {
      @chart.colors = ['#000000', 'NOTHEX']
    }.should raise_error(ArgumentError)
  end
end

describe "it sets default values", :shared => true do
  it 'colors' do
    @chart.colors.should == Seer::Chart::DEFAULT_COLORS
  end

  it 'legend' do
    @chart.legend.should == Seer::Chart::DEFAULT_LEGEND_LOCATION
  end

  it 'height' do
    @chart.height.should == Seer::Chart::DEFAULT_HEIGHT
  end

  it 'width' do
    @chart.width.should == Seer::Chart::DEFAULT_WIDTH
  end
end