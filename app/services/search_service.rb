# A service to search over active record collection.
# This class accepts hash of params and builds the SQL query out of it, then
# executes the query in the given collection
#
# Example:
# @collection = User.active
# @search_options = [ { :key => 'name', :value => 'Co' } ]
#
# When the above input is passed, the service returns all the active users
# whose name is starting with 'Co'.
#

class SearchService

  def initialize(collection, search_options)
    # search options is an array of objects with key value pair
    @collection = collection
    @search = search_options || []
    @columns = collection.columns.map(&:name) rescue raise_invalid_input
  end

  def search
    conditions = @search.map do |hash|

      hash = hash.to_h.symbolize_keys!
      raise ('Invalid Key: ' + hash[:key]) unless @columns.include?(hash[:key])

      ( hash[:key] && hash[:value] ) ? ["#{hash[:key]} ILIKE (?)", "%#{hash[:value]}%"] : nil
    end.
    compact

    query = conditions.map(&:first).join(" OR ")
    @collection.where(query, *conditions.map(&:second))
  end

  private

  def raise_invalid_input
    raise "Invalid input"
  end

end