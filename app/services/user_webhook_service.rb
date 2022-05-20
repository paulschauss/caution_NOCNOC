require 'uri'
require 'net/http'
require 'openssl'

class UserWebhookService
  def call
    set_url
    result = set_webhook
  end

  def set_url
    @url = URI("https://api.lodgify.com/webhooks/v1/subscribe")
  end

  def set_webhook
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(url)
    request["Accept"] = 'text/plain'
    request["Content-Type"] = 'application/*+json'
    request["X-ApiKey"] = 'F47yidcmfdkYz4xCRDOX+QuQ7ruYWRHHWZyzbogicwqJsrBI8Gb4pQtCGBNZKpAx'

    ## attention a bien remplacé NOTRE_APP_URL
    ## par un truc du style https://notre_app_nocnoc.com/webhooks/bookings
    request.body = "{\"target_url\":\"NOTRE_APP_URL\",\"event\":\"booking_change\"}"

    response = http.request(request)
    return JSON.parse(response.read_body)
  end
end
