require 'sinatra/reloader'
require 'sinatra/base'
require 'slim'

    

class App < Sinatra::Base
#class Root < Sinatra::Base
  configure do
    enable :sessions
    $default_work_stamina = 100
    $after_work_stamina = 100
    $risk = 0
    $after_work_life = 100
    $money = 0
    $estimation = 0
  end

  get '/' do
    dead_end()
    slim :index
  end
  
  get '/order' do
    message_clear() 
    # 仕事を受注する
    $estimation = 100
    redirect '/'
  end
  
  get '/work_do' do
    if done?($estimation, $after_work_stamina)
      $after_work_stamina -= $estimation.to_i
      work_done()
    else
      $estimation -= $after_work_stamina
      $message_danger = "もうはたらけません"
      $after_work_stamina = 0
      $motto_work_flag = "gogogo"
    end
    slim :index
  end
  
  def message_clear() 
    $message_work = nil
    $message_danger = nil
    $plus_money = nil
  end
  
  # お仕事完了判定
  def done?(estimation, stamina)
    if estimation > stamina
      false
    else
      true
    end
  end
  
  # お仕事完了時の処理（スタミナとライフ以外）
  def work_done()
    message_clear() 
    # $message_work = "お仕事完了♪"

    $estimation = 0

    # お給料を増やす
    $plus_money = rand(10000..50000).to_i
    $money += $plus_money
    
    # 障害チャンス
    if $risk >= 100
      $message_danger = "障害リスクが高まっています"
      $syogaichance = "syogaichance!!!!"
    end
    
    redirect '/'
  end
  
  # 終了チェック
  def dead_end()
    if $after_work_life <= 0
      redirect '/game_over'
    end
  end
  
  get '/motto_work_do' do
    if done?($estimation.to_i / 5, $after_work_life)
      $after_work_life -= $estimation.to_i / 5
      work_done()
    else
      redirect '/game_over'
    end
    redirect '/'
  end

  get '/unyo_do' do 
    $risk += 50
    work_done()
    redirect '/'
  end
  
  get '/syogaichance' do
    message_clear() 
    roll = rand(1..10).to_i 
    if roll < 4
      $message_danger = "レベルB障害が出ました"
      if $after_work_life <= 1
        $after_work_life = 0
      else
        $after_work_life = 1
      end
      $money = ($money / 2).floor
    elsif roll >= 4 && roll < 8
      $message_work = "レベルB障害が出ましたが内部発見のためセーフ。改善が行われました"
      $after_work_life -= 10
      $risk = $risk / 2
    else
      $message_work = "障害リスクが高まったので改善が行われました"
      $after_work_life -= 10
      $risk = $risk / 2
    end
    $plus_money = nil
    $syogaichance = nil
    redirect '/'
  end

  get '/logout' do
  	session.clear
    $after_work_stamina = 100
    $risk = 0
    $after_work_life = 100
    $money = 0
    $motto_work_flag = nil
    $estimation = 0
    $syogaichance = nil
    message_clear() 
    $stopflag = nil

    redirect '/'
  end
  
  get '/game_over' do
    $stopflag = "stop"
    $message_danger = "ゲームオーバー。もうはたらけません"
    slim :index
  end


end

# class Main < Sinatra::Base
#   ROUTES = {
#     '/' => Root
#   }
# end
