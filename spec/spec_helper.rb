$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'rubygems'
require 'actionpack'
require 'active_support'
require 'spec'
require 'spec/autorun'
require 'seer'
require File.dirname(__FILE__) + "/custom_matchers"  
require File.dirname(__FILE__) + '/helpers'
Spec::Runner.configure do |config|
  config.include(CustomMatcher)  
end
