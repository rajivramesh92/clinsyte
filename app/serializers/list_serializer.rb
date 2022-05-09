class ListSerializer < BaseSerializer

  attributes :id,
    :name,
    :options

  private

  def options
    serialize_collection(object.options, OptionSerializer)
  end
end