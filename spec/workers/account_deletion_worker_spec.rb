describe AccountDeletionWorker do

  describe '#perform' do

    context 'when the worker gets executed' do
      let!(:unconfirmed_users) { FactoryGirl.create_list(:user, 20) }
      let!(:confirmed_users) { FactoryGirl.create_list(:user, 10) }

      before do
        confirmed_users.each { | user | user.email_verify! }
        stub_const('ENV', ENV.to_h.merge!({
          "UNCONFIRMED_ACCOUNT_DELETION_PERIOD" => '2'
        }))  # 2 weeks
      end

      it 'should not remove the unconfirmed accounts within the configured period' do
        Timecop.travel 10.days do
          AccountDeletionWorker.new.perform
          expect(User.unconfirmed.count).to eq(20)
        end
      end

      it 'should remove all the unconfirmed accounts extending the configured period' do
        Timecop.travel 16.days do
          AccountDeletionWorker.new.perform
          expect(User.unconfirmed.count).to eq(0)
        end
      end

    end
  end
end
