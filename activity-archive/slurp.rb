#! /usr/bin/env ruby
# copy all json source for activities to local resource

require "rubygems"
require "json"
require "net/http"
require "uri"
require "erb"


SERVER = "smartgraphs-authoring.concord.org"
PUBLIC_ACTIVITIES_PATH = "activities.json"
OUT_DIR = File.join(Dir.pwd, "_site")
OUT_JSON = File.join(OUT_DIR, "public_activities.json")
LOCAL_ACTIVITIES = File.join(OUT_DIR, "activities")
INDEX_ERB = File.join(Dir.pwd, "index.html.erb")

activities_json_url = "http://#{SERVER}/#{PUBLIC_ACTIVITIES_PATH}"
activities_base = "http://#{SERVER}/activities/"

uri = URI.parse(activities_json_url)
http = Net::HTTP.new(uri.host, uri.port)
request = Net::HTTP::Get.new(uri.request_uri)

response = http.request(request)

if response.code == "200"
  hash_result = JSON.parse(response.body).map do |doc|
      act = doc['activity']
      slug = act['name'].downcase.gsub(/[^a-z]+/,'-')
      { 'activity'=> {
          'author_name' => act['author_name'],
          'cc_project_name' => act['cc_project_name'],
          'id'=> act['id'],
          'name' => act['name'],
          'remote_url' => "#{activities_base}#{act['id']}/student_preview.html",
          'local_url' => "#{act['id']}-#{slug}.html"
        }
    }
  end

  out = JSON.pretty_generate(hash_result)
  File.open(OUT_JSON,'w') { |f| f.write(out)}

  hash_result.each do |k|
    v = k['activity']
    uri = URI.parse(v['remote_url'])
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Get.new(uri.request_uri)
    request.content_type = 'text/html'
    response = http.request(request)
    if response.code == "200"
      File.open(File.join(OUT_DIR,v['local_url']),'w') do |f|
        f.write(response.body)
      end
    else
      puts "Error slurping #{v['local_url']}"
      puts $!
    end
  end

  activities = hash_result.map { |a| a['activity'] }.sort { |a,b|
    a['name'].downcase <=> b['name'].downcase
  }
  template = ERB.new(File.read(INDEX_ERB))
  index_content = template.result()

  File.open(File.join(OUT_DIR, 'index.html'),'w') do |f|
    f.write(index_content)
  end

else
  puts "ERROR!!!"
  puts response
  puts url_string
end
