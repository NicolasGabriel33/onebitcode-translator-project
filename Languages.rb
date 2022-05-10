require 'net/https'
require 'uri'
require 'cgi'
require 'json'

class Languages
    def initialize(endpoint,path)
        endpoint = endpoint
        path = path

        uri = URI (endpoint + path)

        request = Net::HTTP::Get.new(uri)

        response = Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
            http.request (request)
        end

        result = response.body.force_encoding("utf-8")

        json = JSON.parse(result)

        language_names = json.to_hash
        name_list = {}
        language_names["translation"].each_pair do |key,value|
            name_list["#{key}"] = value["name"]
        end
    
        output_path = 'available_languages.txt'

        File.open(output_path, 'w' ) do |line|
            line.print name_list
        end
    end

    def self.file_list
        output_path = 'available_languages.txt'
        language_file = File.read(output_path)
        file = JSON.parse(language_file.gsub!('=>',':'))
        file
    end

    def self.names
        output_path = 'available_languages.txt'
        language_file = File.read(output_path)
        file = JSON.parse(language_file.gsub!('=>',':'))
        list = []
        file.each_value { |v| list << v}
        list.sort!
    end

    def self.list(names)
        names = names
        i = 0
        name_list = [] 
        names.each do |value|
            i +=1
            name_list << "#{i} - #{value}"
        end
        name_list
    end
end