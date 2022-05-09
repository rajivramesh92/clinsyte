class BaseSerializer < ActiveModel::Serializer

  # Disable the root element
  self.root = false

  private

  def serialize_collection(collection, serializer)
    collection.map do | object |
      serializer.new(object).as_json
    end
  end

end
