describe ListOptionCountingService do

  describe "#response_data" do
    let!(:physician) { FactoryGirl.create(:user_with_physician_role) }
    let!(:survey) { FactoryGirl.create(:survey, :creator => physician) }

    let!(:list) { FactoryGirl.create(:list) }
    let!(:option1) { FactoryGirl.create(:option, :list => list) }
    let!(:option2) { FactoryGirl.create(:option, :list => list) }
    let!(:option3) { FactoryGirl.create(:option, :list => list) }
    let!(:option4) { FactoryGirl.create(:option, :list => list) }

    let!(:question) { FactoryGirl.create(:question, :type => 'ListDrivenQuestion', :survey => survey, :list => list) }

    let!(:patient1) { FactoryGirl.create(:user) }
    let!(:patient2) { FactoryGirl.create(:user) }
    let!(:patient3) { FactoryGirl.create(:user) }
    let!(:patient4) { FactoryGirl.create(:user) }
    let!(:patient5) { FactoryGirl.create(:user) }
    let!(:patient6) { FactoryGirl.create(:user) }

    let!(:physician1) { FactoryGirl.create(:user_with_physician_role) }
    let!(:physician2) { FactoryGirl.create(:user_with_physician_role) }

    let!(:request1) { FactoryGirl.create(:user_survey_form, :sender => physician, :receiver => patient1, :survey => survey, :state => 'submitted') }
    let!(:request2) { FactoryGirl.create(:user_survey_form, :sender => physician, :receiver => patient2, :survey => survey, :state => 'submitted') }
    let!(:request3) { FactoryGirl.create(:user_survey_form, :sender => physician, :receiver => patient3, :survey => survey, :state => 'submitted') }
    let!(:request4) { FactoryGirl.create(:user_survey_form, :sender => physician, :receiver => patient4, :survey => survey, :state => 'submitted') }
    let!(:request5) { FactoryGirl.create(:user_survey_form, :sender => physician1, :receiver => patient5, :survey => survey, :state => 'submitted') }
    let!(:request6) { FactoryGirl.create(:user_survey_form, :sender => physician2, :receiver => patient6, :survey => survey, :state => 'submitted') }

    let!(:careteam1) { FactoryGirl.create(:careteam, :patient => patient1) }
    let!(:careteam2) { FactoryGirl.create(:careteam, :patient => patient2) }
    let!(:careteam3) { FactoryGirl.create(:careteam, :patient => patient3) }
    let!(:careteam4) { FactoryGirl.create(:careteam, :patient => patient4) }

    before do
      careteam1.add_member(physician)
      careteam2.add_member(physician)
      careteam3.add_member(physician)
      careteam4.add_member(physician)

      # Question responses
      answer1 = request1.list_driven_answers.create(:question => question, :creator => patient1, :selected_options_attributes => [{:option => option2.name}, {:option => option4.name}])
      answer2 = request2.list_driven_answers.create(:question => question, :creator => patient2, :selected_options_attributes => [{:option => option1.name}])
      answer3 = request3.list_driven_answers.create(:question => question, :creator => patient3, :selected_options_attributes => [{:option => option3.name}, {:option => option1.name}])
      answer4 = request4.list_driven_answers.create(:question => question, :creator => patient4, :selected_options_attributes => [{:option => option2.name}])
      answer5 = request5.list_driven_answers.create(:question => question, :creator => patient5, :selected_options_attributes => [{:option => option1.name}])
      answer6 = request6.list_driven_answers.create(:question => question, :creator => patient6, :selected_options_attributes => [{:option => option3.name}])
    end

    context "when the user attempts to get the data for List Driven question" do
      context "when the question type is incorrect" do
        let!(:question2) { FactoryGirl.create(:question, :type => 'RangeBasedQuestion') }

        it "should return error message stating 'Invalid question type'" do
          expect(ListOptionCountingService.new(question2, physician, nil).response_data).to eq({
           :error => "Invalid question type"
        })
        end
      end

      context "when no response has been submitted for the question" do
        let!(:list2) { FactoryGirl.create(:list) }
        let!(:option1) { FactoryGirl.create(:option, :list => list2) }
        let!(:option2) { FactoryGirl.create(:option, :list => list2) }
        let!(:question2) { FactoryGirl.create(:question, :type => 'ListDrivenQuestion', :list => list2) }

        it "should return counts as 0 for every option" do
          responses = ListOptionCountingService.new(question2, physician, nil).response_data
          expect(responses[:careteam_response].map { |response| response[:count] }.uniq).to eq([])
          expect(responses[:global_response].map { |response| response[:count] }.uniq).to eq([])
        end
      end

      context "when the user attempts to compare careteam data with the global data" do
        it "should return the proper counts for options" do
          responses = ListOptionCountingService.new(question, physician, nil).response_data

          # Calculation of Statistical Data
          careteam_patients = physician.associated_patients
          careteam_answers = question.answers.where("creator_id IN (?)", careteam_patients)
          counts = SelectedOption.where(:list_driven_answer => careteam_answers).group(:option).count
          careteam_counts = counts.map { | option, count | {:option => option, :count => count} }

          global_answers = question.answers
          counts = SelectedOption.where(:list_driven_answer => global_answers).group(:option).count
          global_counts = counts.map { | option, count | {:option => option, :count => count} }

          careteam_response = responses[:careteam_response].map{ |response| { :option => response[:option], :count => response[:count] } }
          global_response = responses[:global_response].map{ |response| { :option => response[:option], :count => response[:count] } }

          expect(careteam_counts).to match_array(careteam_response)
          expect(global_counts).to match_array(global_response)
        end
      end
    end

    context "when the admin user requests the data for List Driven Question" do
      let!(:admin) { FactoryGirl.create(:user_with_admin_role) }

      it "should return only global response" do
        responses = ListOptionCountingService.new(question, admin, nil).response_data

        global_answers = question.answers
        counts = SelectedOption.where(:list_driven_answer => global_answers).group(:option).count
        global_counts = counts.map { | option, count | {:option => option, :count => count} }

        global_response = responses[:global_response].map{ |response| { :option => response[:option], :count => response[:count] } }
        expect(global_counts).to match_array(global_response)
      end
    end

    context "when the patient user is passed with question and current user" do
      it "should return the response for careteam response, global response and patient's response" do
        responses = ListOptionCountingService.new(question, physician, patient2).response_data

        patient_answers = question.answers.where(:creator => patient2)
        counts = SelectedOption.where(:list_driven_answer => patient_answers).group(:option).count
        patient_counts = counts.map { | option, count | {:option => option, :count => count} }

        patient_response = responses[:patient_response].map{ |response| { :option => response[:option], :count => response[:count] } }
        expect(patient_counts).to match_array(patient_response)
      end
    end

    context "when wrong parameters are given to the service" do
      context "when the question object is nil" do
        it "should raise exception" do
          expect do
            responses = ListOptionCountingService.new(nil, physician, nil).response_data
          end
          .to raise_exception('Invalid parameters')
        end
      end

      context "when the user object is nil" do
        it "should raise exception" do
          expect do
            responses = ListOptionCountingService.new(question, nil, nil).response_data
          end
          .to raise_exception('Invalid parameters')
        end
      end
    end

  end
end