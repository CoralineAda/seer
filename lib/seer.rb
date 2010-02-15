# FIXME
#   geomappable(
#     :latitude_field => :latitude,
#     :longitude_field => :longitude,
#     :label => 'Locale'
#     :values => {
#       :keyword => :keyword_count
#     }
#   )
# 
# This adds a to_geomap_data_table CLASS method to the model.
# 
#   chartable(
#     :label => 'Keyword'
#     :values => {
#       'Quality Score' => :wordtracker_score
#     }
#   )
#
# This adds a to_data_table CLASS method to the model and handles general visualiation types.

module Seer

  def self.valid_hex_number?(val)
    ! (val =~ /^\#([0-9]|[a-f]|[A-F])+$/).nil? && val.length == 7
  end

  def self.log(message)
    RAILS_DEFAULT_LOGGER.info(message)
  end
  
end

