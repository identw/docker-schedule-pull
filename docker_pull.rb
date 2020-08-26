#!/usr/bin/env ruby

require 'rest-client'
require 'json'

docker_hub_url = "https://hub.docker.com"
account = "identw"

repositories = RestClient.get("#{docker_hub_url}/v2/repositories/#{account}", headers: {
    'Content-type' => 'Application/json',
})

repositories = JSON.parse(repositories)

repositories['results'].each do |repo|
  repo_name = repo['name']
  repo =  RestClient.get("#{docker_hub_url}/v2/repositories/#{account}/#{repo['name']}/tags", headers: {
      'Content-type' => 'Application/json',
  })
  repo = JSON.parse(repo)
  repo['results'].each do |image|
    puts "### Pull #{account}/#{repo_name}:#{image['name']}"
    system("docker pull #{account}/#{repo_name}:#{image['name']}")
  end
  puts ""
end


