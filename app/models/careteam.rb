class Careteam < ActiveRecord::Base

  # Associations
  belongs_to :patient, :class_name => 'User'
  has_many :careteam_memberships
  has_many :members, :through => :careteam_memberships

  # Validations
  validates_presence_of :patient

  # Delegations
  delegate :primary_physician, :make_primary!, :membership_level_of, :primary_membership, {
    :to => :careteam_memberships
  }
  delegate :sent_requests, :to => :patient

  # Aliases
  alias_method :invites, :sent_requests

  # Tracking version of records
  has_associated_audits

  def add_member(member)
    begin
      if member.physician?
        add_physician(member)
      else
        # Adding the physician to careteam as the patient
        Audited.audit_class.as_user(patient) do
          members << member
        end
      end
    rescue ActiveRecord::RecordInvalid
      "Already a member"
    end
  end

  def physicians
    members.physicians
  end

  def add_physician(physician)
    if physician.physician?
      # Adding the physician to careteam as the patient
      Audited.audit_class.as_user(patient) do
        members << physician
        make_primary!(physician) unless careteam_memberships.primary_membership.present?
      end
    else
      "Must be a physician"
    end
  end

  def all_audits
    associated_audits.reorder(:created_at => :desc)
  end

  def remove_member(member)
    careteam_memberships.find_by(:member => member).try(:destroy)
  end

  def cancel_invite(member, delete_notification = false)
    query = "(sender_id = ? AND recipient_id = ?)"
    request = Request.pending.where("#{query} OR #{query}", member.id, patient_id, patient_id, member.id).last
    if request.try(:pending?)
      request.cancel!
      request.delete_notification if delete_notification
      return true
    end
  end
end
