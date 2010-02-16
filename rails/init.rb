#Allow whatever Ruby Package tool is being used to manage load paths.  gem auto adds the gem's lib dir to load path.
require 'seer' unless defined?(Seer)

ActionController::Base.send :include, Seer::VisualizationHelper

RAILS_DEFAULT_LOGGER.info("** Seer: initialized properly")
