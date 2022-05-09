class Api::V1::Users::PasswordsController < Api::V1::BaseController
  include Concerns::PasswordReset
end