class SuccessSerializer < BaseSerializer

  attributes :status, :message

  def status
    "success"
  end

  def message
    {}
  end

end