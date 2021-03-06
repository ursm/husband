# vim:fileencoding=utf-8
require 'sinatra'
require 'configatron'
require 'ohm'
Ohm.connect
require_relative '../model/user'
require 'bunny'

configatron.configure_from_yaml(File.dirname(__FILE__)+"/../config/config.yml")
raise "Add config/config.yml" if configatron.nil?

bunny = Bunny.new
bunny.start
operation_queue = bunny.queue('operation')

get '/' do
  'hi'
end

post '/new' do
  if params['keyword'] == configatron.husband.keyword
  puts User.create({:twitter_id => params['twitter_id'], :notifo_username => params['notifo_username'], :twitter_screen_name => params['twitter_screen_name']})
  operation_queue.publish("reload")
  else
    raise "Can't received"
  end
end
