namespace :contact do
  desc "contact guest before he leaves"
  task client: :environment do
    puts "Contacting clients"
    ContactClientsService.new.call
  end
end

## to run:

# rake contact:client

## or if you want to run it only one environment

# rake contact:client environment=development ## or ## rake contact:client environment=production
