#! /usr/bin/env ruby
# copy all json source for activities to local resource

require "rubygems"
require "json"
require "net/http"
require "uri"


SERVER = "smartgraphs-authoring.staging.concord.org"
PUBLIC_ACTIVITIES_PATH = "activities.json"
OUT_DIR = File.join(Dir.pwd, "_site")
OUT_JSON = File.join(OUT_DIR, "public_activities.json")
LOCAL_ACTIVITIES = File.join(OUT_DIR, "activities")

activities_json_url = "http://#{SERVER}/#{PUBLIC_ACTIVITIES_PATH}"
activities_base = "http://#{SERVER}/activities/"

uri = URI.parse(activities_json_url)
http = Net::HTTP.new(uri.host, uri.port)
request = Net::HTTP::Get.new(uri.request_uri)

response = http.request(request)

if response.code == "200"
  hash_result = JSON.parse(response.body).map do |doc|
      act = doc['activity']
      slug = act['name'].downcase.gsub(/[^a-z]/,'_')
      { 'activity'=> {
          'author_name' => act['author_name'],
          'cc_project_name' => act['cc_project_name'],
          'id'=> act['id'],
          'name' => act['name'],
          'remote_url' => "#{activities_base}#{act['id']}/student_preview.html",
          'local_url' => "#{act['id']}_#{slug}.html"
        }
    }
  end

  out = JSON.pretty_generate(hash_result)
  File.open(OUT_JSON,'w') { |f| f.write(out)}

  hash_result.each do |k|
    v = k['activity']
    puts "Key: #{k}"
    puts "Value: #{v}"
    puts v['remote_url']
    uri = URI.parse(v['remote_url'])
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Get.new(uri.request_uri)
    response = http.request(request)
    if response.code == "200"
      File.open(File.join(OUT_DIR,v['local_url']),'w') { |f| f.write(out)}
    else
      puts "Error slurping #{v['local_url']}"
      puts $!
    end
  end

else
  puts "ERROR!!!"
  puts response
  puts url_string
end
