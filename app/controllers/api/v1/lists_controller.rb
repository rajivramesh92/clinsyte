class Api::V1::ListsController < Api::V1::BaseController

  authorize_resource
  before_filter :set_list, :except => [ :index, :create ]

  def index
    lists = List.all
    success_serializer_responder(lists, ListSerializer)
  end

  def show
    success_serializer_responder(@list.options, ListSerializer)
  end

  def create
    list = List.new(list_params)
    if list.save
      success_serializer_responder(list, ListSerializer)
    else
      error_serializer_responder("List creation failed")
    end
  end

  def update
    begin
      @list.update!(list_params)
      success_serializer_responder(@list.reload, ListSerializer)
    rescue
      error_serializer_responder(@list, ListSerializer)
    end
  end

  def destroy
    begin
      @list.inactive!
      success_serializer_responder("List removed successfully")
    rescue
      error_serializer_responder("List removal failed")
    end
  end

  private

  def list_params
    params.permit(
      :id,
      :name,
      :status,
      :options_attributes => [
        :id,
        :name,
        :status
      ]
    )
  end

  def set_list
    @list = List.find(params[:id]) rescue nil
    error_serializer_responder("List not found") unless @list.present?
  end

end
