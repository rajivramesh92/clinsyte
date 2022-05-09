describe Api::V1::QuestionsController do
  describe "#statistics" do

    context "when the user is logged in" do
      context "as physician" do
        let!(:physician) { FactoryGirl.create(:user_with_physician_role) }
        before do
          token_sign_in(physician)
        end

        context "when the user attempts to collect statistics for a question" do
          let!(:survey) { FactoryGirl.create(:survey, :creator => physician) }

          let!(:patient1) { FactoryGirl.create(:user) }
          let!(:patient2) { FactoryGirl.create(:user) }
          let!(:patient3) { FactoryGirl.create(:user) }
          let!(:patient4) { FactoryGirl.create(:user) }
          let!(:patient5) { FactoryGirl.create(:user) }
          let!(:patient6) { FactoryGirl.create(:user) }

          let!(:careteam1) { FactoryGirl.create(:careteam, :patient => patient1) }
          let!(:careteam2) { FactoryGirl.create(:careteam, :patient => patient2) }
          let!(:careteam3) { FactoryGirl.create(:careteam, :patient => patient3) }
          let!(:careteam4) { FactoryGirl.create(:careteam, :patient => patient4) }

          let!(:request1) { FactoryGirl.create(:user_survey_form, :sender => physician, :receiver => patient1, :survey => survey, :state => 'submitted') }
          let!(:request2) { FactoryGirl.create(:user_survey_form, :sender => physician, :receiver => patient2, :survey => survey, :state => 'submitted') }
          let!(:request3) { FactoryGirl.create(:user_survey_form, :sender => physician, :receiver => patient3, :survey => survey, :state => 'submitted') }
          let!(:request4) { FactoryGirl.create(:user_survey_form, :sender => physician, :receiver => patient4, :survey => survey, :state => 'submitted') }
          let!(:request5) { FactoryGirl.create(:user_survey_form, :sender => physician1, :receiver => patient5, :survey => survey, :state => 'submitted') }
          let!(:request6) { FactoryGirl.create(:user_survey_form, :sender => physician2, :receiver => patient6, :survey => survey, :state => 'submitted') }

          let!(:physician1) { FactoryGirl.create(:user_with_physician_role) }
          let!(:physician2) { FactoryGirl.create(:user_with_physician_role) }

          before do
            careteam1.add_member(physician)
            careteam2.add_member(physician)
            careteam3.add_member(physician)
            careteam4.add_member(physician)
          end

          context "when the user attempts to get the data for MCQ questions" do
            let!(:question) { FactoryGirl.create(:question, :type => 'MultipleChoiceQuestion', :survey => survey) }
            let!(:option1) { FactoryGirl.create(:choice, :question => question) }
            let!(:option2) { FactoryGirl.create(:choice, :question => question) }
            let!(:option3) { FactoryGirl.create(:choice, :question => question) }
            let!(:option4) { FactoryGirl.create(:choice, :question => question) }

            before do
              request1.multiple_choice_answers.create(:question => question, :choice_id => option1.id, :creator => patient1)
              request2.multiple_choice_answers.create(:question => question, :choice_id => option2.id, :creator => patient2)
              request3.multiple_choice_answers.create(:question => question, :choice_id => option3.id, :creator => patient3)
              request4.multiple_choice_answers.create(:question => question, :choice_id => option4.id, :creator => patient4)
              request5.multiple_choice_answers.create(:question => question, :choice_id => option3.id, :creator => patient5)
              request6.multiple_choice_answers.create(:question => question, :choice_id => option2.id, :creator => patient6)
            end

            context "when the user attempts to compare careteam data with the global data" do
              let(:params) do
                {
                  :id => question.id,
                  :type => 'mcq_option_counts'
                }
              end

              it "should compute the results and return proper data" do
                get :statistic, params

                responses = JSON.parse(response.body)
                careteam_counts =  [{option1.id => 1}, {option2.id => 1}, {option3.id => 1}, {option4.id => 1} ]
                global_counts = [{option1.id => 1}, {option2.id => 2}, {option3.id => 2}, {option4.id => 1} ]
                expect(responses["careteam_response"].map { |response| { response["option"]["id"] => response["count"] } }).to eq(careteam_counts)
                expect(responses["global_response"].map { |response| { response["option"]["id"] => response["count"] } }).to eq(global_counts)
              end
            end

            context "when the user attempts to compare his patient data with careteam and global population data" do
              let(:params) do
                {
                  :id => question.id,
                  :type => 'mcq_option_counts',
                  :patient_id => patient1.id
                }
              end

              it "should compute the results and return proper data" do
                get :statistic, params

                responses = JSON.parse(response.body)
                patient_counts = [{option1.id => 1}, {option2.id => 0}, {option3.id => 0}, {option4.id => 0} ]
                careteam_counts =  [{option1.id => 1}, {option2.id => 1}, {option3.id => 1}, {option4.id => 1} ]
                global_counts = [{option1.id => 1}, {option2.id => 2}, {option3.id => 2}, {option4.id => 1} ]

                expect(responses["patient_response"].map { |response| { response["option"]["id"] => response["count"] } }).to eq(patient_counts)
                expect(responses["careteam_response"].map { |response| { response["option"]["id"] => response["count"] } }).to eq(careteam_counts)
                expect(responses["global_response"].map { |response| { response["option"]["id"] => response["count"] } }).to eq(global_counts)
              end
            end
          end

          context "when the user attempts to get the data for the Whiskers Chart" do
            let!(:question) { FactoryGirl.create(:question, :type => 'RangeBasedQuestion', :min_range => 1, :max_range => 10, :survey => survey) }

            before do
              request1.range_based_answers.create(:question => question, :value => 5, :creator => patient1)
              request2.range_based_answers.create(:question => question, :value => 8, :creator => patient2)
              request3.range_based_answers.create(:question => question, :value => 3, :creator => patient3)
              request4.range_based_answers.create(:question => question, :value => 9, :creator => patient4)
              request5.range_based_answers.create(:question => question, :value => 1, :creator => patient5)
              request6.range_based_answers.create(:question => question, :value => 6, :creator => patient6)
            end

            context "when the user attempts to compare careteam data with global data" do
              let(:params) do
                {
                  :id => question.id,
                  :type => 'whiskers_chart_data'
                }
              end

              it "should compute the result and return data" do
                get :statistic, params

                expect(JSON.parse(response.body)).to eq({
                  "careteam_response" =>  {
                    "min" => 3,
                    "max" => 9,
                    "median" => 6.5,
                    "first_quartile" => 4.0,
                    "third_quartile" => 8.5
                  },
                  "global_response" => {
                    "min" => 1,
                    "max" => 9,
                    "median" => 5.5,
                    "first_quartile" => 3.0,
                    "third_quartile" => 8.0
                  }
                })
              end
            end

            context "when the user attempts to compare his patient data with his careteam and global population data" do
              let!(:request7) { FactoryGirl.create(:user_survey_form, :sender => physician, :receiver => patient1, :survey => survey, :state => 'submitted') }
              let!(:request8) { FactoryGirl.create(:user_survey_form, :sender => physician, :receiver => patient1, :survey => survey, :state => 'submitted') }
              let!(:request9) { FactoryGirl.create(:user_survey_form, :sender => physician, :receiver => patient1, :survey => survey, :state => 'submitted') }
              let(:params) do
                {
                  :id => question.id,
                  :type => 'whiskers_chart_data',
                  :patient_id => patient1.id
                }
              end

              before do
                request7.range_based_answers.create(:question => question, :value => 2, :creator => patient1)
                request8.range_based_answers.create(:question => question, :value => 9, :creator => patient1)
                request9.range_based_answers.create(:question => question, :value => 6, :creator => patient1)
              end

              it "should compute the result and return data" do
                get :statistic, params

                expect(JSON.parse(response.body)).to eq({
                  "patient_response" => {
                    "min" => 2,
                    "max" => 9,
                    "median" => 5.5,
                    "first_quartile" => 3.5,
                    "third_quartile" => 7.5
                    },
                  "careteam_response" =>  {
                    "min" => 2,
                    "max" => 9,
                    "median" => 6.0,
                    "first_quartile" => 3.0,
                    "third_quartile" => 9.0
                  },
                  "global_response" => {
                    "min" => 1,
                    "max" => 9,
                    "median" => 6.0,
                    "first_quartile" => 2.5,
                    "third_quartile" => 8.5
                  }
                })
              end
            end

            context "when the user attempts to get the data when enough responses has not been given" do
              let!(:patient7) { FactoryGirl.create(:user) }
              let(:params) do
                {
                  :id => question.id,
                  :type => 'whiskers_chart_data',
                  :patient_id => patient7.id
                }
              end

              it "should return error stating 'Insufficient data to plot Whiskers graph'" do
                get :statistic, params

                expect(JSON.parse(response.body)).to eq({
                  "patient_response" => {
                    "error" => "Insufficient data to plot Whiskers graph"
                  },
                  "careteam_response" =>  {
                    "min" => 3,
                    "max" => 9,
                    "median" => 6.5,
                    "first_quartile" => 4.0,
                    "third_quartile" => 8.5
                  },
                  "global_response" => {
                    "min" => 1,
                    "max" => 9,
                    "median" => 5.5,
                    "first_quartile" => 3.0,
                    "third_quartile" => 8.0
                  }
                })
              end
            end
          end
        end
      end
    end
  end
end