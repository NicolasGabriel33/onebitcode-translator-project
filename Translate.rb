require 'net/https'
require 'uri'
require 'cgi'
require 'json'
require 'securerandom'

class Translate
    def initialize(subscription_key,region_key,endpoint,path)
        @subscription_key = subscription_key
        @region_key = region_key
        @endpoint = endpoint
        @path = path
    end
    
    def traduzindo(from ,to,text)
        from = "&from=#{from}"
        to = "&to=#{to}"

        uri = URI (@endpoint + @path + from + to)

        text = text

        content = '[{"Text" : "' + text + '"}]'

        request = Net::HTTP::Post.new(uri)
        request['Content-type'] = 'application/json'
        request['Content-length'] = content.length
        request["Ocp-Apim-Subscription-Key"] = @subscription_key
        request["Ocp-Apim-Subscription-Region"] = @region_key
        request['X-ClientTraceId'] = SecureRandom.uuid
        request.body = content

        response = Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
            http.request (request)
        end

        result = response.body.force_encoding("utf-8")

        json = JSON.pretty_generate(JSON.parse(result))
        json = JSON.parse(result)
        json
    end
end