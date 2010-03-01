module CustomMatcher  
  def set_cell(row, column, value)
    value = "'#{value}'" if value.is_a?(String)
    
    simple_matcher("setCell(#{row}, #{column}, #{value})") do |actual|
      actual =~ /data\.setCell\(#{row},\s*#{column},\s*#{value}\)/
    end
  end  
  
  def set_value(row, column, value)
    value = "'#{value}'" if value.is_a?(String)
    
    simple_matcher("setValue(#{row}, #{column}, #{value})") do |actual|
      actual =~ /data\.setValue\(#{row},\s*#{column},\s*#{value}\)/
    end
  end  
  
  def add_column(column_type, value)
    simple_matcher("addColumn('#{column_type}', '#{value}')") do |actual|
      actual =~ /data\.addColumn\('#{column_type}',\s*'#{value}'\)/
    end
  end
end