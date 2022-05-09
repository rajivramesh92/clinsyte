class UserSerializer < BaseSerializer

  attributes :id,
    :email,
    :first_name,
    :last_name,
    :gender,
    :country_code,
    :phone_number,
    :ethnicity,
    :birthdate,
    :uuid,
    :role,
    :license_id,
    :expiry,
    :name,
    :preferred_device,
    :time_zone,
    :admin,
    :study_admin

  private

  def role
    object.role.try(:name)
  end

  def birthdate
    object.birthdate.to_time.strftime("%s%3N") rescue nil
  end

  def name
    object.user_name
  end

  def expiry
    {
      :date => object.expiry.day,
      :month => object.expiry.month,
      :year => object.expiry.year
    } rescue nil
  end

  def phone_number
    object.phone_number.to_s if object.phone_number.present?
  end

  def admin
    object.admin?
  end

  def study_admin
    object.study_admin?
  end

end