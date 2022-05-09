class TemplateSerializer < BaseSerializer

  attributes :id,
    :name,
    :strain,
    :message

  private

  def strain
    StrainSerializer.new(object.strain).as_json
  end

  def message
    object.template_data.message
  end

end