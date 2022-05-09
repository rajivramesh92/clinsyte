class ErrorSerializer < BaseSerializer

  attributes :status, :errors

  def status
    "error"
  end

  def errors
    []
  end

end