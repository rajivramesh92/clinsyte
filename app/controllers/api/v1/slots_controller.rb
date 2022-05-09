class Api::V1::SlotsController < Api::V1::BaseController

  before_action :set_slot, :only => [:update, :destroy]
  authorize_resource

  # Endpoint to create slots
  def create
    slot = current_user.slots.new(slot_params)
    slot.save ? success_serializer_responder(slot, SlotSerializer) : error_serializer_responder(slot)
  end

  # Endpoint to update a slots
  def update
    if @slot.update(slot_params)
      success_serializer_responder(@slot, SlotSerializer)
    else
      error_serializer_responder(@slot)
    end
  end

  # Endpoint to remove the slots
  def destroy
    @slot.destroy ? success_serializer_responder("Slot removed successfully") : error_serializer_responder(@slot)
  end

  private

  def slot_params
    if params[:type].eql?('available')
      params.permit(*slot_keys).merge(:type => 'AvailableSlot')
    else
      params.permit(*slot_keys, :date).merge(:type => 'UnavailableSlot')
    end
  end

  def slot_keys
    [ :day, :from_time, :to_time ]
  end

  def set_slot
    begin
      @slot = Slot.find(params[:id])
    rescue
      error_serializer_responder('Slot does not exist')
    end
  end

end
