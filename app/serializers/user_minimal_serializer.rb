class UserMinimalSerializer < BaseSerializer
  attributes :id,
    :name,
    :gender,
    :role,
    :location,
    :admin,
    :study_admin

  def name
  	object.user_name
  end

  def gender
    object.gender.to_s.capitalize
  end

  def role
    object.role.try(:name).to_s
  end

  def location
    object.location.to_s.capitalize
  end

  def admin
    object.admin?
  end

  def study_admin
    object.study_admin?
  end

end
