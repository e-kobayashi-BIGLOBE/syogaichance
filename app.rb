require 'sinatra/reloader'
require 'sinatra/base'
require 'slim'

    

class App < Sinatra::Base
#class Root < Sinatra::Base
  configure do
    enable :sessions
    $after_work_stamina = 100
    $risk = 0
    $after_work_life = 100
    $motto_work_flag = nil
    $message_work = nil
    $money = 0
  end


  get '/' do
    session[:stamina] = $after_work_stamina
    session[:life] = $after_work_life
    slim :index
  end
  
  get '/work_do' do
    estimation = 80
    before_work_stamina = session[:stamina] 
    session[:stamina] = before_work_stamina.to_i - estimation.to_i
    $after_work_stamina = session[:stamina]
    
    # スタミナが0以下になったら0にする
    if $after_work_stamina < 0
      $message_work = "もうはたらけません"
      $after_work_stamina = 0
      $motto_work_flag = "gogogo"
    else
      $message_work = "お仕事完了♪"
    end
    redirect '/'
  end
  
  get '/motto_work_do' do
    estimation = 10
    before_work_life = session[:life] 
    session[:life] = before_work_life.to_i - estimation.to_i
    $after_work_life = session[:life]
    
    # スタミナが0以下になったら0にする
    if $after_work_life < 0
      redirect '/game_over'
    end
    redirect '/'
  end

  get '/unyo_do' do 
    # todo 実装する
  end

  get '/logout' do
  	session.clear
    $after_work_stamina = 100
    $risk = 0
    $after_work_life = 100
    $message_work = nil
    $money = 0
    
    redirect '/'
  end
  
  get '/game_over' do
    "ざんねんでした"
    #slim :game_over
  end


end

# class Main < Sinatra::Base
#   ROUTES = {
#     '/' => Root
#   }
# end
