module TimeFilterSharedExample

  shared_examples_for "time_filter" do | resource |

    context "when the filter value is present" do
      before do
        FactoryGirl.create_list(resource, 10)
      end

      context "when the user attempts to filter the record with date" do
        it "should return the matching records" do
          expect(described_class.filter_by_time(Time.zone.now.strftime("%d/%m/%y")).count).to eq(described_class.where('DATE(created_at) = ?', Time.now.utc.to_date).count)
        end
      end

      context "when the user provides some Invalid date as the filter" do
        it "should return empty array" do
          expect(described_class.filter_by_time('09-08-16')).to eq([])
        end
      end

      context "when the user provides filter as 'last 2 weeks'" do
        before do
          Timecop.travel(2.weeks.ago) do
            FactoryGirl.create_list(resource, 10)
          end
        end

        it "should return the records created in the last 2 weeks from now" do
          expect(described_class.filter_by_time("last 2 weeks").count).to eq(described_class.where('DATE(created_at) >= ?', 2.weeks.ago).count)
        end
      end

      context "when the user provides filter as 'last 2 months'" do
        before do
          Timecop.travel(2.months.ago) do
            FactoryGirl.create_list(resource, 10)
          end
        end

        it "should return the records created in the last 2 months from now" do
          expect(described_class.filter_by_time("last 2 months").count).to eq(described_class.where('DATE(created_at) >= ?', 2.months.ago).count)
        end
      end

      context "when the user provides filter as 'last 2 years'" do
        before do
          Timecop.travel(2.years.ago) do
            FactoryGirl.create_list(resource, 10)
          end
          Timecop.travel(3.years.ago) do
            FactoryGirl.create_list(resource, 10)
          end
        end

        it "should return the records created in the last 2 years from now" do
          expect(described_class.filter_by_time("last 2 years").count).to eq(described_class.where('DATE(created_at) >= ?', 2.years.ago).count)
        end
      end

      context "when the user provides filter as 'last 2 something'" do
        it "should return the empty array" do
          expect(described_class.filter_by_time("last 2 something")).to eq([])
        end
      end

    end

    context "when the filter value is nil" do
      it "should return the empty array" do
        expect(described_class.filter_by_time(nil)).to eq([])
      end
    end

  end
end
