require 'sinatra'
require 'slim'
require './lib/github'

configure { set :server, :puma }

get '/' do
  lang = GitHub.get_language(params[:user]) if !params[:user].nil?
  slim :index, locals: {language: lang}
end
