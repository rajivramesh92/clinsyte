# if Rails.env.production? && ENV['IS_STAGING_SERVER']

#   module Sidekiq::Worker
#     module ClassMethods
#       def perform_async(args)
#         retry_count = sidekiq_options_hash["retry"] || 0

#         begin
#           self.new.perform(args)
#         rescue StandardError => e
#           retry_count = retry_count-1
#           retry if ( retry_count > 0 )
#           return
#         end
#       end
#     end
#   end

# end