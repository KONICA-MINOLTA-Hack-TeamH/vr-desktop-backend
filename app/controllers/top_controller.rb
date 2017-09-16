class TopController < ApplicationController
  def index
  end
  
  def get_next_send_mail
    #Ringからのリクエストを受けて、最新のメールを取得する
    #session[:next_send_mail]に保存する
    #session[:sended_for_unity]=falseにする
  end
  
  def send_mail_for_unity
    #session[:next_send_mail]を取得してRender
    #session[:sended_for_unity]=trueにする
    #    json = {
    #      :text => session[:latest_email]
    #    }
  end

  def send_email_for_unity
    json = {
      :text => "test"
    }
    render :json => json
  end

  def new_mail_arrive?
    #最新のメールが既読かどうかを判定してunityに送る
    #session[:next_send_mail]と、最新email情報が一致するかどうか調べる

  end

  def feach_gmail
    format.html{ render :nothing => true }
    gmail = Gmail.new("h.akaishi.dev@gmail.com", "19940927")

    puts gmail.inbox.count
  end
  
end  

