require 'sinatra'
require 'slim'
require './lib/github'

configure { set :server, :puma }

get '/' do
  lang = GitHub.get_language(params[:user]) if GitHub.valid_username?(params[:user])
  slim :index, locals: {language: lang}
end
