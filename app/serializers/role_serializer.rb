class RoleSerializer < SuccessSerializer

  def message
    {
      :name => object.name
    }
  end

end
