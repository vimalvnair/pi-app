require 'bundler'
Bundler.setup
Bundler.require

set :bind, '0.0.0.0'
set :port, 80

RED_PIN=4
GREEN_PIN=17
BLUE_PIN=27

get '/' do
  slim :index
end

post '/set_color' do
  puts params[:color]
  initialize_pins

  red_pwm = RPi::GPIO::PWM.new(RED_PIN, 100)
  green_pwm = RPi::GPIO::PWM.new(GREEN_PIN, 100)
  blue_pwm = RPi::GPIO::PWM.new(BLUE_PIN, 100)

  red_pwm.start 0
  green_pwm.start 0
  blue_pwm.start 0

  colors = params[:color].scan(/../).map{|c| c.to_i(16) }
  puts colors.inspect
  red_pwm.duty_cycle = (colors[0]/255.0) * 100
  green_pwm.duty_cycle = (colors[1]/255.0) * 100
  blue_pwm.duty_cycle = (colors[2]/255.0) * 100
  response.set_cookie 'color', params[:color]
  redirect to("/")
end

post'/turn_off' do
  initialize_pins

  red_pwm = RPi::GPIO::PWM.new(RED_PIN, 100)
  green_pwm = RPi::GPIO::PWM.new(GREEN_PIN, 100)
  blue_pwm = RPi::GPIO::PWM.new(BLUE_PIN, 100)

  red_pwm.stop
  green_pwm.stop
  blue_pwm.stop

  RPi::GPIO.clean_up RED_PIN
  RPi::GPIO.clean_up GREEN_PIN
  RPi::GPIO.clean_up BLUE_PIN
  redirect to("/")
end

def initialize_pins
  RPi::GPIO.set_numbering :bcm

  RPi::GPIO.setup RED_PIN, :as => :output
  RPi::GPIO.setup GREEN_PIN, :as => :output
  RPi::GPIO.setup BLUE_PIN, :as => :output
end
