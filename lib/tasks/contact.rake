namespace :contact do
  desc "send the quote before he arrives"
  task before_start: :environment do
    puts "executing contact:before_start task"
    ContactBeforeStartService.new.call
  end

  desc "contact guest before he leaves"
  task before_end: :environment do
    puts "executing contact:before_end task"
    ContactBeforeEndService.new.call
  end
end

## to run:

#     namespace
#         |
#         v
# rake contact:before_start
#                   ^
#                   |
#                 task


## or if you want to run it only one environment

# rake contact:before_start environment=development ## or ## rake contact:before_start environment=production
