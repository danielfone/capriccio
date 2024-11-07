require 'sinatra'
require 'yaml'
require 'securerandom'

enable :sessions
set :session_secret, ENV.fetch('SESSION_SECRET') { SecureRandom.hex(64) }


SCENES = Dir.glob('scenes/*.yml').flat_map { |f| YAML.load_file(f) }

get '/' do
  scene = SCENES.first
  pp scene
  render_scene(scene)
end

get '/scene/:id' do
  scene = SCENES.find { |r| r['id'] == params[:id] } or halt 404
  hint = params[:hint].to_i if params[:hint]
  @scene_name = scene['name']

  render_scene(scene, hint:)
end

post '/scene/:id/unlock' do
  key = params[:key] or halt 400
  scene = SCENES.find { |r| r['id'] == params[:id] } or halt 404
  answer = scene.dig('lock', 'answer') or halt 404
  opens = scene.dig('lock', 'opens') or halt 404

  if answer_matches?(key, answer)
    # Set the session variable to remember that the scene has been unlocked
    session[params[:id]] = true
    redirect to("/scene/#{opens}")
  else
    error = scene.dig('lock', 'errors')&.sample || "Try again"
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

def render_scene(scene, hint: nil, key: nil, error: nil)
  erb :scene, layout: :main, locals: { scene:, key:, error:, hint: }
end

# This method is used to compare the user's input with the expected answer
# It is case-insensitive and ignores non-word characters, i.e. punctuation
def answer_matches?(actual, expected)
  actual.downcase.gsub(/\W/, '') == expected.downcase.gsub(/\W/, '')
end

helpers do
  def simple_format(text)
    text.to_s.split("\n\n").map { |line| "<p>#{line}</p>" }.join
  end
end
