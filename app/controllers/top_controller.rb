class TopController < ApplicationController
  def index
  end

  def fetch_gmail
    begin
      gmail = Gmail.new("h.akaishi.dev@gmail.com", "19940927")
      mail = gmail.inbox.emails(:all).last
      mail_hash = {}
      mail_hash[:subject] = mail.subject
      mail_hash[:date] = mail.date
      mail_hash[:from] = mail.from[0]
      mail_hash[:to] = mail.to[0]
      mail_hash[:text] = mail.text_part.decoded
      mail_hash[:subject] = mail.subject
    rescue
      mail = gmail.inbox.emails(:all).last
      mail_hash = {}
      mail_hash[:subject] = "sample subject"
      mail_hash[:date] = "2017 - 9 -17"
      mail_hash[:from] = "sender@gmail.com"
      mail_hash[:to] = "myaddress@gmail.com"
      mail_hash[:text] = "sampleのテキストです！"
      mail_hash[:subject] = "sampleのメールです!"
    end
    p mail_hash
    #    return mail_hash.to_json
    #    render :json => mail_hash.to_json
#    $next_send_mail = mail_hash
    return mail_hash
  end
  
  def get_next_send_mail
    #Ringからのリクエストを受けて、最新のメールを取得する
    #session[:next_send_mail]に保存する
    #session[:sended_for_unity]=falseにする
    
#    session[:next_send_mail] = fetch_gmail
#    session[:sended_for_unity] = false
$next_send_mail = fetch_gmail
$sended_for_unity = false
    p "get_next",$next_send_mail,$sended_for_unity
    render :plain => "get!"
  end
  
  def send_mail_for_unity
    #session[:next_send_mail]を取得してRender
    #session[:sended_for_unity]=trueにする
#    p "send_mail", session[:next_send_mail],session[:sended_for_unity]
    p "send_mail", $next_send_mail ,$sended_for_unity
#    if session[:sended_for_unity]
     if $sended_for_unity
     #送ってあるなら何も返さない
     p "send: sended" 
      render :json => "sended"
    else
      #送ってないなら送ってsession[:sended_for_unity] = true
#      session[:seneded_for_unity] = true
      $sended_for_unity = true
     p "send: mail",$sended_for_unity 
#      render :json => session[:next_send_mail].to_json
      render :json => $next_send_mail.to_json
    end
  end

  def send_email_for_unity
    json = {
      :text => "test"
    }
    render :json => json
  end

  def new_mail_arrive
    #最新のメールが既読かどうかを判定してunityに送る
    #session[:next_send_mail]と、最新email情報が一致するかどうか調べる
    text = "test"
    new_mail = fetch_gmail
#    if new_mail != session[:next_send_mail]
    if new_mail != $next_send_mail
      #最新のメールはRingからのリクエストでとったものと一致しない時
      text = "exist"
    else
      text = "none"
    end
    
    render :json => text
  end
  
end  

