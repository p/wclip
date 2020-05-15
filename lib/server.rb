require 'daybreak'
autoload :Byebug, 'byebug'
require 'sinatra'

class App < Sinatra::Base
  configure :development do
    require 'sinatra/reloader'
    register Sinatra::Reloader
  end

  get '/*' do
    path = params[:splat].first
    content_type = db["content_type:#{path}"]
    if content_type
      body = db["body:#{path}"]
      response.headers['content-type'] = content_type
      body
    else
      halt(404)
    end
  end

  post '/*' do
    write
  end

  put '/*' do
    write
  end

  def db
    @db ||= Daybreak::DB.new("/tmp/wclip.db")
  end

  def write
    path = params[:splat].first
    content_type = request.env['CONTENT_TYPE']
    body = request.body.read
    db.synchronize do
      db["content_type:#{path}"] = content_type
      db["body:#{path}"] = body
      db.flush
    end
    ''
  end
end
