$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

require 'rankstar'
require 'spec'
require 'spec/autorun'

Spec::Runner.configure do |config|
  
end
