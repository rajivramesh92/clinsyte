# Base controller for All the APIs
# All the API controllers needs to inherit from this controller

class Api::V1::BaseController < ::ApplicationController

  # Including token authable helpers
  include DeviseTokenAuth::Concerns::SetUserByToken

  # Allowing requests which dont have valid authentication tokens
  protect_from_forgery :with => :null_session

  before_filter :authenticate_user!

  private

  def success_serializer_responder(data={}, obj_serializer=SuccessSerializer, meta={})
    json = { :status => "success" }
    if data.is_a?(ActiveRecord::Relation)
      json[:data] = ActiveModel::ArraySerializer.new(data, :each_serializer => obj_serializer)
    elsif data.is_a?(ActiveRecord::Base)
      json[:data] = obj_serializer.new(data)
    else
      json[:data] = data
    end

    render :json => json
  end

  def error_serializer_responder(data={}, obj_serializer=ErrorSerializer, meta={})
    json = { :status => "error" }
    if data.is_a?(ActiveRecord::Base)
      json[:errors] = data.errors.customized_full_messages
    else
      json[:errors] = data
    end

    render :json => json
  end

  def paginate(collection)
    PaginationService.new(collection, {
      :page => params[:page],
      :count => params[:count]
    }).paginate
  end

end