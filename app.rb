require 'bundler'
Bundler.setup
Bundler.require

set :bind, '0.0.0.0'
set :port, 80

RED_PIN=17
GREEN_PIN=18
BLUE_PIN=22

get '/' do
  slim :index
end

post '/set_color' do
  puts params[:color]

  colors = params[:color].scan(/../).map{|c| c.to_i(16) }
  puts colors.inspect
  `echo "#{RED_PIN}=#{colors[0]/255.0}" > /dev/pi-blaster`
  `echo "#{GREEN_PIN}=#{colors[1]/275.0}" > /dev/pi-blaster`
  `echo "#{BLUE_PIN}=#{colors[2]/320.0}" > /dev/pi-blaster`
  response.set_cookie 'color', params[:color]
  redirect to("/")
end

