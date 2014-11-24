require 'sinatra'
require 'slim'
require './lib/github'

configure { set :server, :puma }

# CLIENT_ID = ENV['GH_BASIC_CLIENT_ID']
# CLIENT_SECRET = ENV['GH_BASIC_SECRET_ID']

get '/' do
  lang = GitHub.get_language(params[:user]) if !params[:user].nil?
  # Pass in the CLIENT_ID for the login button on the home page.
  slim :index, locals: {language: lang}
end
