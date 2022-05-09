describe TagSerializer do

  context "when the user attempts to display the object using TagSerializer" do
    let!(:tag) { FactoryGirl.create(:tag) }

    it "should display the object using the attributes defined in the TagSerializer" do
      expect(TagSerializer.new(tag).as_json).to eq(
        {
          :id => tag.id,
          :name => tag.name,
          :tag_group => tag.tag_group
        }
      )
    end
  end
end