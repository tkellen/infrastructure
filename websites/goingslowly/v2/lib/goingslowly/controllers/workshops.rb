module GS
  class App < Sinatra::Base
    subdomain '' do
      get '/course/grindbygg-timber-frame-workshop' do
        redirect 'http://journal.goingslowly.com/2013/04/timber-framing-course-norwegian-grindbygg-trestle-frame-workshop', 301
      end
    end
  end
end
