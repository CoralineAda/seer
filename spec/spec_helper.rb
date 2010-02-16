$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'actionpack'
require 'activesupport'
require 'spec'
require 'spec/autorun'
require 'seer'

Spec::Runner.configure do |config|

end
