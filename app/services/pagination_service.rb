class PaginationService

  DEFAULT_PAGE = 1
  DEFAULT_COUNT = (ENV['PAGINATION_COUNT'] || 10).to_i

  def initialize(collection, options={})
    @collection = collection || []
    @page = (options[:page] || DEFAULT_PAGE).to_i rescue raise_invalid_input
    @count = (options[:count] || DEFAULT_COUNT).to_i rescue raise_invalid_input
  end

  def paginate
    return @collection if @collection.empty?

    if @collection.all? { |object| object.is_a?(ActiveRecord::Base) }
      @result = active_record_collection
    else
      @result = array
    end
  end

  # pagination for array collection
  def array
    index = (@page - 1) * @count
    @collection[index...index+@count] || []
  end

  # pagination for active record objects
  def active_record_collection
    @collection.limit(@count).offset(@count * (@page-1))
  end

  private

  def raise_invalid_input
    raise "Inputs are invalid"
  end

end