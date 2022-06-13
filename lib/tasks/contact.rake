namespace :contact do
  desc "send the quote before he arrives"
  task one_day_before_checkin: :environment do
    puts "executing contact:one_day_before_checkin task"
    OneDayBeforeCheckinService.new.call
  end

  desc "contact guest before he leaves"
  task one_day_before_checkout: :environment do
    puts "executing contact:one_day_before_checkout task"
    OneDayBeforeCheckoutService.new.call
  end

  desc "prevent on slack if there are missing deposits"
  task missing_deposit: :environment do
    puts "executing contact:missing_deposit task"
    MissingDepositService.new.call
  end
end

## to run:

#     namespace
#         |
#         v
# rake contact:one_day_before_checkout
#                        ^
#                        |
#                      task


## or if you want to run it only one environment

# rake contact:one_day_before_checkout environment=development ## or ## rake contact:one_day_before_checkout environment=production
