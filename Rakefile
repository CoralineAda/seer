require 'rubygems'
require 'rake'
require 'echoe'

Echoe.new('seer', '0.5.0') do |p|
  p.description     = "A lightweight, semantically rich wrapper for the Google Visualization API."
  p.url             = "http://github.com/Bantik/seer"
  p.author          = "Corey Ehmke / SEO Logic"
  p.email           = "corey@seologic.com"
  p.ignore_pattern  = ["tmp/*","script/*"]
  p.development_dependencies = []
end
Dir["#{File.dirname(__FILE__)}/tasks/*.rake"].sort.each { |ext| load ext }

