class CareteamSerializer < BaseSerializer

  attributes :id,
    :patient

  def patient
    UserMinimalSerializer.new(object.patient).as_json
  end

end