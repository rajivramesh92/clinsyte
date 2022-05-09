# A Service to filter the records based on some key value pairs
# collection => represents the record which needs to be filtered
# filters => is an array of objects having key as column name and values as their values

# Example :
# @filters = [ { :key => 'sender_id', :value => 2 } ]

class FilterService

  def initialize(collection, filter_options)
    @collection = collection
    @filters = filter_options || []
    @columns = collection.columns.map(&:name) rescue raise_invalid_input
  end

  def filter
    @filters.map do | filter |
      filter = filter.to_h.symbolize_keys!
      raise ('Invalid Key: ' + filter[:key]) unless @columns.include?(filter[:key])
      @collection = ( filter[:key].present? && filter[:value].present? ) ? @collection.where("#{filter[:key]}".to_sym =>  filter[:value]) : @collection
    end
    .compact

    @collection
  end

  def raise_invalid_input
    raise "Invalid input"
  end

end