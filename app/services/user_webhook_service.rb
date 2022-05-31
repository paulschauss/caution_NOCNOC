require 'uri'
require 'net/http'
require 'openssl'

class UserWebhookService
  def call
    set_url
    set_webhook
  end

  def set_url
    @url = URI("https://api.lodgify.com/webhooks/v1/subscribe")
  end

  def set_webhook
    http = Net::HTTP.new(@url.host, @url.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(@url)
    request["Accept"] = 'text/plain'
    request["Content-Type"] = 'application/*+json'
    request["X-ApiKey"] = ENV.fetch("LODGIFY_API_KEY")

    request.body = "{\"target_url\":\"https://caution-nocnoc-staging.herokuapp.com/webhooks/bookings\",\"event\":\"booking_change\"}"

    response = http.request(request)
    puts response.read_body
  end
end
