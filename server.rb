require 'sinatra'
require 'yaml'

SCENES = Dir.glob('scenes/*.yml').flat_map { |f| YAML.load_file(f) }

get '/' do
  scene = SCENES.first
  pp scene
  render_scene(scene)
end

get '/scene/:id' do
  scene = SCENES.find { |r| r['id'] == params[:id] } or halt 404

  render_scene(scene)
end

post '/scene/:id/unlock' do
  key = params[:key] or halt 400
  scene = SCENES.find { |r| r['id'] == params[:id] } or halt 404
  answer = scene.dig('lock', 'answer') or halt 404
  opens = scene.dig('lock', 'opens') or halt 404

  if key == answer
    redirect to("/scene/#{opens}")
  else
    error = scene.dig('lock', 'errors').sample
    render_scene(scene, key:, error:)
  end
end

not_found do
  erb "404: The Vogon Constructor Fleet has destroyed the page you are looking for.", layout: :main
end

error 400 do
  erb "400: I'm sorry, Dave. I'm afraid I can't do that.", layout: :main
end

error do
  erb "500: I'm sorry, Dave. I'm afraid I can't do that.", layout: :main
end

def render_scene(scene, key: nil, error: nil)
  erb :scene, layout: :main, locals: { scene:, key:, error: }
end

helpers do
  def simple_format(text)
    text.to_s.split("\n\n").map { |line| "<p>#{line}</p>" }.join
  end
end
