describe Api::V1::TherapiesController do
  it_should_behave_like "searchable", "strain"

  describe "#show" do
    context "when the user is not logged in" do
      it "should return error message stating 'Authorized access only'" do
        get :show, :id => 1

        expect_unauthorized_access
        expect_json_content
        expect(json['errors']).to include("Authorized users only.")
      end
    end

    context "when the user is logged in" do
      let!(:physician) { FactoryGirl.create(:user_with_physician_role) }

      let!(:strain) { FactoryGirl.create(:strain) }

      let!(:compound1) { FactoryGirl.create(:compound) }
      let!(:compound2) { FactoryGirl.create(:compound) }
      let!(:compound3) { FactoryGirl.create(:compound) }

      # Connecting compounds with Strains
      let!(:compound1_strain_connection) { FactoryGirl.create(:compound_strain, :compound => compound1, :strain => strain) }
      let!(:compound2_strain_connection) { FactoryGirl.create(:compound_strain, :compound => compound2, :strain => strain) }
      let!(:compound3_strain_connection) { FactoryGirl.create(:compound_strain, :compound => compound3, :strain => strain) }

      let!(:tag1) { FactoryGirl.create(:tag) }
      let!(:tag2) { FactoryGirl.create(:tag) }
      let!(:tag3) { FactoryGirl.create(:tag) }

      before do
        # Connecting tags to Strain-Compound Associations
        compound1_strain_connection.tag_connections.create(:tag => tag1)
        compound1_strain_connection.tag_connections.create(:tag => tag2)
        compound3_strain_connection.tag_connections.create(:tag => tag1)
        compound3_strain_connection.tag_connections.create(:tag => tag3)
      end

      # Response should come like

      # tagged commpound => [
      #   tag 1 => compound1, compound3
      #   tag 2 => compound 1
      #   tag 3 => compound 3
      # ]

      # untagged compound => [ compound 2 ]

      context "as physician" do
        before do
          token_sign_in(physician)
        end

        it "should return the strain with compounds grouped under tags" do
          get :show, :id => strain.id

          expect_success_status
          expect_json_content
          expect(json['status']).to eq('success')

          response = json["data"]
          tags = strain.compound_strains.map { |compound_strain| compound_strain.tags }.flatten.uniq

          response_tag_compound_grouping = response["tag_with_compounds"].map do |object|
            {
               :tag => object["tag"]["id"],
               :compounds => object["compounds"].map { |compound| compound["id"] }
            }
          end

          tag_compound_grouping = tags.map do |tag|
            {
              :tag => tag.id,
              :compounds => tag.compound_strain_connections.map do |compound_strain_connection|
                              compound = compound_strain_connection.compound_strain.compound
                              compound.id if strain.compounds.include?(compound)
                            end
                            .compact
            }
          end

          response_untagged_compund_grouping = response["untagged_compounds"].map { |compound| compound["id"] }

          compound_strain_connection_ids = strain.compound_strains.map &:id

          tagged_compound_strain_ids = CompoundStrainTagConnection.where(:compound_strain_id => compound_strain_connection_ids).map(&:compound_strain_id).uniq
          untagged_compound_connection_ids = compound_strain_connection_ids - tagged_compound_strain_ids
          untagged_compound_grouping = untagged_compound_connection_ids.map do |compound_strain_id|
                                        compound_strain_object = CompoundStrain.find(compound_strain_id)

                                        compound_strain_object.compound.id
                                      end

          # Spec for tagged therapies
          expect(response_tag_compound_grouping).to match_array(tag_compound_grouping)

          # Spec for untagged therapies
          expect(response_untagged_compund_grouping).to match_array(untagged_compound_grouping)
        end

      end
    end
  end
end
