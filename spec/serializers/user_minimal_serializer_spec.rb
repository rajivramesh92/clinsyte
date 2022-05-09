describe UserMinimalSerializer do

  context "When an object is described using UserMinimal Serializer" do
    let(:resource) { FactoryGirl.create(:user) }

    it "should render the object using the attributes specified in UserMinimal Serializer" do
      expect(UserMinimalSerializer.new(resource).as_json).to include({
        :id => resource.id,
        :name => resource.user_name,
        :gender => resource.gender.capitalize,
        :location => resource.location.capitalize,
        :admin => resource.admin?,
        :study_admin => resource.study_admin?
      })
    end
  end

end