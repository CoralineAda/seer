module Seer

  def self.valid_hex_number?(val) #:nodoc:
    ! (val =~ /^\#([0-9]|[a-f]|[A-F])+$/).nil? && val.length == 7
  end

  def self.log(message) #:nodoc:
    RAILS_DEFAULT_LOGGER.info(message)
  end
  
end

class ActionView::Base
  include Seer::VisualizationHelper
end
