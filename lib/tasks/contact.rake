namespace :contact do
  desc "contact guest before he leaves"
  task client: :environment do
    puts "Contacting clients"
    ContactClientsService.new.call
  end
end
