require 'sinatra/base'
require 'json'
require_relative '../museums/service'

class App < Sinatra::Base
  post '/api/museum/add' do
    museum_data = JSON.parse(request.body.read)
    result = Museums::Service.store(museum_data)
    translations = Museums::Service.store_translations(museum_data['translations'], result[:id]) if museum_data['translations']
    result[:translations] = translations
    result.to_json
  end

  post '/api/museum/retrieve' do
    response.headers['Access-Control-Allow-Origin'] = '*'
    body = JSON.parse(request.body.read)
    result = Museums::Service.retrieve(body['id'])
    result.to_json
  end

  post '/api/museum/list' do
    response.headers['Access-Control-Allow-Origin'] = '*'
    result = Museums::Service.list
    result.to_json
  end

  get '/api/museum/flush' do
    Museums::Service.flush
    {}
  end
end
