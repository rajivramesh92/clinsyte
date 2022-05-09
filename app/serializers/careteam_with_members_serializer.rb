class CareteamWithMembersSerializer < CareteamSerializer

  attributes :members

  private

  def members
    object.careteam_memberships.includes(:member).map do | membership |
      UserMinimalSerializer.new(membership.member).as_json.
        merge(:careteam_role => membership.level) rescue nil
    end
  end

end
