describe WhiskersChartService do

  describe "#response_data" do
    let!(:physician) { FactoryGirl.create(:user_with_physician_role) }
    let!(:survey) { FactoryGirl.create(:survey, :creator => physician) }
    let!(:question) { FactoryGirl.create(:question, :type => 'RangeBasedQuestion',:min_range => 1, :max_range => 10, :survey => survey) }

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

    context "when the user attempts to get Whiskers Chart data" do
      context "when the question type is incorrect" do
        let!(:question1) { FactoryGirl.create(:question, :type => 'MultipleChoiceQuestion') }

        it "should raise error" do
          expect(WhiskersChartService.new(question1, physician, nil).response_data).to eq({
            :error => "Invalid question type"
            }
          )
        end
      end

      # ToDo => Remove Hard Coded values
      context "when the question type is correct" do
        it "should compute the responses and return proper data" do
          expect(WhiskersChartService.new(question, physician, nil).response_data).to eq(
            {
              :careteam_response => {
                :min => 3,
                :max => 9,
                :median => 6.5,
                :first_quartile => 4.0,
                :third_quartile => 8.5
              },
              :global_response => {
                :min => 1,
                :max => 9,
                :median => 5.5,
                :first_quartile => 3.0,
                :third_quartile => 8.0
              }
            }
          )
        end
      end

      context "when no response has been given for the question" do
        let!(:question2) { FactoryGirl.create(:question, :type => 'RangeBasedQuestion', :survey => survey) }

        it "should return error stating 'Insufficient data to plot Whiskers Graph'" do
          expect(WhiskersChartService.new(question2, physician, nil).response_data).to eq(
            {
              :careteam_response => {
                :error => "Insufficient data to plot Whiskers graph"
              },
              :global_response => {
                :error => "Insufficient data to plot Whiskers graph"
              }
            }
          )
        end
      end

      context "when only one response has been given for the question" do
        let!(:question3) { FactoryGirl.create(:question, :type => 'RangeBasedQuestion', :survey => survey, :min_range => 2, :max_range => 10) }
        let!(:patient5) { FactoryGirl.create(:user) }
        let!(:request5) { FactoryGirl.create(:user_survey_form, :sender => physician, :receiver => patient5, :survey => survey, :state => 'submitted') }
        before do
          request5.range_based_answers.create(:question => question3, :value => 5, :creator => patient5)
        end

        it "should return error stating 'Insufficient data to plot Whiskers Graph'" do
          expect(WhiskersChartService.new(question3, physician, nil).response_data).to eq(
            {
              :careteam_response => {
                :error => "Insufficient data to plot Whiskers graph"
              },
              :global_response => {
                :error => "Insufficient data to plot Whiskers graph"
              }
            }
          )
        end
      end

      context "when wrong parameters are given to the service" do
        context "when the question object is nil" do
          it "should raise exception" do
            expect do
              responses = WhiskersChartService.new(nil, physician, nil).response_data
            end
            .to raise_exception('Invalid parameters')
          end
        end

        context "when the user object is nil" do
          it "should raise exception" do
            expect do
              responses = WhiskersChartService.new(question, nil, nil).response_data
            end
            .to raise_exception('Invalid parameters')
          end
        end
      end
    end

  end

end