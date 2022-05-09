describe RangeFrequenciesService do

  describe "#response_data" do
    let!(:physician) { FactoryGirl.create(:user_with_physician_role) }
    let!(:survey) { FactoryGirl.create(:survey, :creator => physician) }
    let!(:question) { FactoryGirl.create(:question, :type => 'RangeBasedQuestion', :min_range => 1, :max_range => 10, :survey => survey) }

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

      request1.range_based_answers.create(:question => question, :value => 5, :creator => patient1)
      request2.range_based_answers.create(:question => question, :value => 8, :creator => patient2)
      request3.range_based_answers.create(:question => question, :value => 3, :creator => patient3)
      request4.range_based_answers.create(:question => question, :value => 9, :creator => patient4)
      request5.range_based_answers.create(:question => question, :value => 1, :creator => patient5)
      request6.range_based_answers.create(:question => question, :value => 6, :creator => patient6)
    end

    context "when the user attempts to get Frequency data" do
      context "when the question type is incorrect" do
        let!(:question) { FactoryGirl.create(:question, :type => 'MultipleChoiceQuestion', :min_range => 1, :max_range => 10) }

        it "should raise error" do
          expect(RangeFrequenciesService.new(question, physician, nil).response_data).to eq({
            :error => "Invalid question type"
            }
          )
        end
      end

      context "when the data is needed for careteam population and global population" do
        it "should compute the responses and return proper data" do
          responses = RangeFrequenciesService.new(question, physician, nil).response_data

          # Calculations
          min_range = question.min_range
          max_range = question.max_range
          range_counts = Hash[ (min_range..max_range).to_a.map { |value| [value, 0] } ]

          careteam_patients = physician.associated_patients
          careteam_response = Answer.where("creator_id IN (?) and question_id = ?", careteam_patients, question.id).map(&:value)
          careteam_response.each do | answer |
            range_counts[answer] += 1
          end

          expect(responses[:careteam_response]).to eq(range_counts)

          global_response = Answer.where(:question_id => question.id).map(&:value)
          range_counts = Hash[ (min_range..max_range).to_a.map { |value| [value, 0] } ]
          global_response.each do | answer |
            range_counts[answer] += 1
          end

          expect(responses[:global_response]).to eq(range_counts)
        end
      end

      context "when the data is needed for the patients, careteam population and global population" do
        it "should compute the responses and return proper data" do
          responses = RangeFrequenciesService.new(question, physician, patient1).response_data

          # Calculations
          min_range = question.min_range
          max_range = question.max_range
          range_counts = Hash[ (min_range..max_range).to_a.map { |value| [value, 0] } ]

          careteam_patients = physician.associated_patients
          careteam_response = Answer.where("creator_id IN (?) and question_id = ?", careteam_patients, question.id).map(&:value)
          careteam_response.each do | answer |
            range_counts[answer] += 1
          end

          expect(responses[:careteam_response]).to eq(range_counts)

          global_response = Answer.where(:question_id => question.id).map(&:value)
          range_counts = Hash[ (min_range..max_range).to_a.map { |value| [value, 0] } ]
          global_response.each do | answer |
            range_counts[answer] += 1
          end

          expect(responses[:global_response]).to eq(range_counts)

          patient_response = Answer.where("question_id = ? and creator_id = ?", question.id, patient1.id).map(&:value)
          range_counts = Hash[ (min_range..max_range).to_a.map { |value| [value, 0] } ]
          patient_response.each do | answer |
            range_counts[answer] += 1
          end

          expect(responses[:patient_response]).to eq(range_counts)
        end
      end

      context "when admin user requests the data" do
        let!(:admin) { FactoryGirl.create(:user_with_admin_role) }
        it "should return only the global response" do
          responses = RangeFrequenciesService.new(question, admin, nil).response_data

          # Calculations
          min_range = question.min_range
          max_range = question.max_range
          range_counts = Hash[ (min_range..max_range).to_a.map { |value| [value, 0] } ]

          global_response = Answer.where(:question_id => question.id).map(&:value)
          range_counts = Hash[ (min_range..max_range).to_a.map { |value| [value, 0] } ]
          global_response.each do | answer |
            range_counts[answer] += 1
          end

          expect(responses[:global_response]).to eq(range_counts)
          expect(responses[:patient_response]).to be_nil
          expect(responses[:careteam_response]).to be_nil
        end
      end

      context "when no response has been submitted yet" do
        let!(:question1) { FactoryGirl.create(:question, :type => 'RangeBasedQuestion', :min_range => 1, :max_range => 10, :survey => survey) }

        it "should return all the frequencies as 0" do
          responses = RangeFrequenciesService.new(question1, physician, patient1).response_data
          min_range = question.min_range
          max_range = question.max_range
          range_counts = Hash[ (min_range..max_range).to_a.map { |value| [value, 0] } ]
          expect(responses[:careteam_response]).to eq(range_counts)
          expect(responses[:global_response]).to eq(range_counts)
        end
      end

      context "when wrong parameters are given to the service" do
        context "when the question object is nil" do
          it "should raise exception" do
            expect do
              responses = RangeFrequenciesService.new(nil, physician, nil).response_data
            end
            .to raise_exception('Invalid parameters')
          end
        end

        context "when the user object is nil" do
          it "should raise exception" do
            expect do
              responses = RangeFrequenciesService.new(question, nil, nil).response_data
            end
            .to raise_exception('Invalid parameters')
          end
        end
      end
    end
  end
end