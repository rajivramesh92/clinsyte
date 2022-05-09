class PhysicianSlotsSerializer < BaseSerializer

  attributes :free_slots,
    :busy_slots,
    :unavailable_slots

  private

  def free_slots
    serialize_collection(object.slots, SlotSerializer)
  end

  def busy_slots
    serialize_collection(object.busy_slots, BusySlotSerializer)
  end

  def unavailable_slots
    serialize_collection(object.unavailable_slots, SlotSerializer)
  end

end