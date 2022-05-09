describe McqOptionCountingService do

  describe "#response_data" do
    let!(:physician) { FactoryGirl.create(:user_with_physician_role) }
    let!(:survey) { FactoryGirl.create(:survey, :creator => physician) }

    let!(:question) { FactoryGirl.create(:question, :type => 'MultipleChoiceQuestion', :survey => survey) }
    let!(:option1) { FactoryGirl.create(:choice, :question => question) }
    let!(:option2) { FactoryGirl.create(:choice, :question => question) }
    let!(:option3) { FactoryGirl.create(:choice, :question => question) }
    let!(:option4) { FactoryGirl.create(:choice, :question => question) }

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

      request1.multiple_choice_answers.create(:question => question, :choice_id => option1.id, :creator => patient1)
      request2.multiple_choice_answers.create(:question => question, :choice_id => option2.id, :creator => patient2)
      request3.multiple_choice_answers.create(:question => question, :choice_id => option3.id, :creator => patient3)
      request4.multiple_choice_answers.create(:question => question, :choice_id => option4.id, :creator => patient4)
      request5.multiple_choice_answers.create(:question => question, :choice_id => option3.id, :creator => patient5)
      request6.multiple_choice_answers.create(:question => question, :choice_id => option2.id, :creator => patient6)
    end

    context "when the user attempts to get the data for Mcq Based question" do
      context "when the question type is incorrect" do
        let!(:question2) { FactoryGirl.create(:question, :type => 'RangeBasedQuestion') }

        it "should return error message stating 'Invalid question type'" do
          expect(McqOptionCountingService.new(question2, physician, nil).response_data).to eq({
           :error => "Invalid question type"
        })
        end
      end

      context "when no response has been submitted for the question" do
        let!(:question2) { FactoryGirl.create(:question, :type => 'MultipleChoiceQuestion') }
        let!(:option1) { FactoryGirl.create(:choice, :question => question2) }
        let!(:option2) { FactoryGirl.create(:choice, :question => question2) }

        it "should return counts as 0 for every option" do
          responses = McqOptionCountingService.new(question2, physician, nil).response_data
          expect(responses[:careteam_response].map { |response| response[:count] }.uniq).to eq([0])
          expect(responses[:global_response].map { |response| response[:count] }.uniq).to eq([0])
        end
      end

      context "when the user attempts to compare careteam data with the global data" do
        it "should return the proper counts for options" do
          responses = McqOptionCountingService.new(question, physician, nil).response_data

          # Calculation for statistical data
          careteam_counts = Hash[ question.choices.map(&:id).map { |choice| [choice, 0] } ]
          careteam_patients = physician.associated_patients
          careteam_answers = question.answers.where("creator_id IN (?)", careteam_patients)
          careteam_answers.each do | answer |
            careteam_counts[answer.choice_id] += 1
          end

          global_counts = Hash[ question.choices.map(&:id).map { |choice| [choice, 0] } ]
          global_answers = question.answers
          global_answers.each do | answer |
            global_counts[answer.choice_id] += 1
          end

          careteam_response = responses[:careteam_response].map{ |response| { :id => response[:option][:id], :count => response[:count] } }
          global_response = responses[:global_response].map{ |response| { :id => response[:option][:id], :count => response[:count] } }

          expect(careteam_counts.map{ |key, value| { :id => key, :count => value} }).to eq(careteam_response)
          expect(global_counts.map{ |key, value| { :id => key, :count => value} } ).to eq(global_response)
        end
      end

      context "when the admin user requests the data for Multiple Choice Question" do
        let!(:admin) { FactoryGirl.create(:user_with_admin_role) }

        it "should return only global response" do
          responses = McqOptionCountingService.new(question, admin, nil).response_data

          global_counts = Hash[ question.choices.map(&:id).map { |choice| [choice, 0] } ]
          global_answers = question.answers
          global_answers.each do | answer |
            global_counts[answer.choice_id] += 1
          end

          global_response = responses[:global_response].map{ |response| { :id => response[:option][:id], :count => response[:count] } }
          expect(global_counts.map{ |key, value| { :id => key, :count => value} }).to match_array(global_response)
        end
      end

      context "when the patient user is passed with question and current user" do
        it "should return the response for careteam response, global response and patient's response" do
          responses = McqOptionCountingService.new(question, physician, patient2).response_data

          patient_counts = Hash[ question.choices.map(&:id).map { |choice| [choice, 0] } ]
          patient_answers = question.answers.where(:creator => patient2)
          patient_answers.each do | answer |
            patient_counts[answer.choice_id] += 1
          end

          patient_response = responses[:patient_response].map{ |response| { :id => response[:option][:id], :count => response[:count] } }
          expect(patient_counts.map{ |key, value| { :id => key, :count => value} }).to match_array(patient_response)
        end
      end

      context "when wrong parameters are given to the service" do
        context "when the question object is nil" do
          it "should raise exception" do
            expect do
              responses = McqOptionCountingService.new(nil, physician, nil).response_data
            end
            .to raise_exception('Invalid parameters')
          end
        end

        context "when the user object is nil" do
          it "should raise exception" do
            expect do
              responses = McqOptionCountingService.new(question, nil, nil).response_data
            end
            .to raise_exception('Invalid parameters')
          end
        end
      end

    end
  end
end