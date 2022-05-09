class Ability
  include CanCan::Ability

  def initialize(user, params)
    user ||= User.new

    # Abilities for authorized users
    unless user.new_record?
      can [:read, :unread], Notification do | notification |
        notification.recipient == user
      end
    end

    if user.admin?
      can [:index, :show, :create, :update, :destroy], Survey
      can :manage, List
      can :statistic, Question
    end

    if user.study_admin?
      can [:index, :show, :create, :update, :destroy, :send_requests, :requests], Survey
      can :statistic, Question
    end

    if user.support?
      can :update, Request
    end

    if user.patient?
      # Abilities for patients
      can [:create, :update], Request
      can [:select_physician, :deselect_physician, :physician], Careteam if user.id.eql?(params[:id].to_i)
      can [ :slots, :make_primary ], User
      can [:index, :create, :pending, :cancel], Appointment
      can [:update, :destroy], Appointment do |appointment|
        appointment.patient.eql?(user)
      end
      can [:show, :requests, :remove_requests], UserSurveyForm
      can [:submit, :start], Survey
      can [:take, :snooze], TreatmentPlanTherapy
    end

    if user.physician?
      # Abilities for Physicians
      can [:create, :update, :index], Request
      can :create, Slot
      can [:update, :slots], User if user.id.eql?(params[:id].to_i)
      can [:update, :destroy], Slot do |slot|
        slot.physician.eql?(user)
      end

      can [:index, :create], Survey
      can [:update, :destroy], Survey do |survey|
        survey.creator.eql?(user)
      end
      can [:show, :send_requests, :requests], Survey do |survey|
        survey.creator.eql?(user) or survey.creator.admin? or survey.creator.study_admin?
      end

      can [:show, :remove_requests], UserSurveyForm
      can [:create, :index, :destroy], SurveyConfiguration

      can [:index, :change_status, :pending, :cancel], Appointment
      can :toggle_auto_confirm, AppointmentPreference do |appointment_preference|
        appointment_preference.physician.eql?(user)
      end
      can :manage, EventDependentSurvey
      can :summary, Careteam
      can :manage, Template
      can :statistic, Question
      can [ :change_owner, :remove_treatment_plan ], TreatmentPlan
    end

    can :update, Request if ( user.counselor? || user.caregiver? )
    can :index, Appointment
  end
end
