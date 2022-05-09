class CreateAdminService
  def call
    user = User.find_or_create_by!(email: ENV['ADMIN_EMAIL']) do |user|
      user.password = ENV['ADMIN_PASSWORD']
      user.password_confirmation = ENV['ADMIN_PASSWORD']
      user.first_name = ENV['ADMIN_FIRSTNAME']
      user.last_name = ENV['ADMIN_LASTNAME']
      user.birthdate = ENV['ADMIN_BIRTHDATE']
      user.ethnicity = ENV['ADMIN_ETHNICITY']
      user.gender = ENV['ADMIN_GENDER']
      user.country_code = ENV['ADMIN_COUNTRY_CODE']
      user.phone_number = ENV['ADMIN_PHONENUMBER']
      user.privilege = User.privileges["admin"]  # assigning admin role
    end
    user.email_verify!
    user
  end
end
