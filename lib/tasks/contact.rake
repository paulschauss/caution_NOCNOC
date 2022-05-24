namespace :contact do
  desc "contact guest before he leaves"
  task client: :environment do
    puts "Contacting client"
    # ContactClientService.new.call
  end
end
