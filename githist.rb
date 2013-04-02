#!/usr/bin/env ruby

require 'octokit'
require 'colorize'
require 'awesome_print'


Octokit.configure do |config|
  config.netrc = true
end


client = Octokit::Client.new
events = client.user_events(client.login)

date = nil
events.each do |event|
  if event.type == 'PushEvent'
    created = DateTime.iso8601(event.created_at)

    if date != created.to_date
      puts "#{created.strftime('%Y-%m-%d')}".magenta
      puts

      date = created.to_date
    end

    puts " #{created.strftime('%H:%M:%S')} - #{event.repo.name}".cyan

    event.payload.commits.each do |commit|
      puts "  - #{commit.message}"
    end

    puts
  end
end
