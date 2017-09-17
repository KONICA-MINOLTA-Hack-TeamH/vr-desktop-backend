class TopController < ApplicationController
  def index
  end

  def fetch_gmail
    begin
      uri = URI.parse('https://www.googleapis.com/gmail/v1/users/me/messages/')
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      req = Net::HTTP::Get.new(uri.request_uri)
      req["Authorization"] = "Bearer ya29.GlvJBKk640NHpwifPH0n4F-NBZcUyumNcUlzt1ChzystF-y3g2kTVLrvo8yGPnKEAX7TgK0trrset66iNC5chQG3jVsu0IB-Q1YJY7vje2GFeuGxU162Crm2jvsK"
      res = http.request(req)

      # puts res.body
      # render :json => JSON.parse(res.body)["messages"][0]["id"]
      id = JSON.parse(res.body)["messages"][0]["id"]

      uri = URI.parse('https://www.googleapis.com/gmail/v1/users/me/messages/' + id)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      req = Net::HTTP::Get.new(uri.request_uri)
      req["Authorization"] = "Bearer ya29.GlvJBKk640NHpwifPH0n4F-NBZcUyumNcUlzt1ChzystF-y3g2kTVLrvo8yGPnKEAX7TgK0trrset66iNC5chQG3jVsu0IB-Q1YJY7vje2GFeuGxU162Crm2jvsK"
      res = http.request(req)

      body = JSON.parse(res.body)["payload"]["parts"].map do |parts|
        parts['body']['data']
      end.join('')
      body = Base64.decode64(body).encode('UTF-8', 'ASCII-8BIT', :invalid => :replace, :undef => :replace)
      response = {
        subject: JSON.parse(res.body)["payload"]['headers'].select{|h|h['name'] == 'Subject'}[0]['value'],
        body: body,
      }
      # render :json => 
      render :json => response
    rescue
      # mail = gmail.inbox.emails(:all).last
      mail_hash = {}
      mail_hash[:subject] = "sample subject"
      mail_hash[:date] = "2017 - 9 -17"
      mail_hash[:from] = "sender@gmail.com"
      mail_hash[:to] = "myaddress@gmail.com"
      mail_hash[:text] = "sampleのテキストです！"
      mail_hash[:subject] = "sampleのメールです!"

      render :json => mail_hash
    end
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

