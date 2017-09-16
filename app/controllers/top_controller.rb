class TopController < ApplicationController
  def index
  end

  def fetch_gmail
    gmail = Gmail.new("h.akaishi.dev@gmail.com", "19940927")
    mail = gmail.inbox.emails(:all).last
    mail_hash = {}
    mail_hash[:subject] = mail.subject
    mail_hash[:date] = mail.date
    mail_hash[:from] = mail.from
    mail_hash[:to] = mail.to
    mail_hash[:text] = mail.text_part.decoded
    mail_hash[:subject] = mail.subject
#    return mail_hash.to_json
    render :json => mail_hash.to_json
  end
  
  def get_next_send_mail
    #Ringからのリクエストを受けて、最新のメールを取得する
    #session[:next_send_mail]に保存する
    #session[:sended_for_unity]=falseにする
    
    session[:next_send_mail] = fetch_gmail
    session[:sended_for_unity] = false
  end
  
  def send_mail_for_unity
    #session[:next_send_mail]を取得してRender
    #session[:sended_for_unity]=trueにする
    
    if session[:sended_for_unity]
      #送ってあるなら何も返さない
      render :nothing
    else
      #送ってないなら送ってsession[:sended_for_unity] = true
      json = {
        :text => session[:next_send_email]
      }
      session[:seneded_for_unity] = true
      render :json => json
    end
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
    
    new_mail = fetch_gmail
    if new_mail != session[:next_send_mail]
      #最新のメールはRingからのリクエストでとったものと一致しない時
      render :text => "true"
    else
      render :text => "false"
    end
  end
  
end  

