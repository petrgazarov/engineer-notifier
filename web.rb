require 'sinatra/base'

class Web < Sinatra::Base
  get '/' do
    'Math is good for you.'
  end
end
