class TopController < ApplicationController
  def index
  end

  def fetch_gmail
#     gmail = Gmail.new("h.akaishi.dev@gmail.com", "19940927")
#     mail = gmail.inbox.emails(:all).last
#     mail_hash = {}
#     mail_hash[:subject] = mail.subject
#     mail_hash[:date] = mail.date
#     mail_hash[:from] = mail.from
#     mail_hash[:to] = mail.to
#     mail_hash[:text] = mail.text_part.decoded
#     mail_hash[:subject] = mail.subject
# #    return mail_hash.to_json
#     render :json => mail_hash.to_json
  uri = URI.parse('https://www.googleapis.com/gmail/v1/users/me/messages/')
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true
  req = Net::HTTP::Get.new(uri.request_uri)
  req["Authorization"] = "Bearer ya29.GlvJBHEftyUIUT_ZU3OeBul-1RKRFT2stUWsutpQXTZV9QW6c5aOyuD88WfHxoss6oCkCM8GLNqanOM0H-be8XnPoRzZVrCq8UZcabm8tsM8vdTsWWWYXISovgj5"
  res = http.request(req)

  # puts res.body
  # render :json => JSON.parse(res.body)["messages"][0]["id"]
  id = JSON.parse(res.body)["messages"][1]["id"]

  uri = URI.parse('https://www.googleapis.com/gmail/v1/users/me/messages/' + id)
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true
  req = Net::HTTP::Get.new(uri.request_uri)
  req["Authorization"] = "Bearer ya29.GlvJBHEftyUIUT_ZU3OeBul-1RKRFT2stUWsutpQXTZV9QW6c5aOyuD88WfHxoss6oCkCM8GLNqanOM0H-be8XnPoRzZVrCq8UZcabm8tsM8vdTsWWWYXISovgj5"
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

