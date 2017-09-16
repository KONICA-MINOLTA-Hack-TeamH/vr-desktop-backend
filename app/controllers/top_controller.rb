class TopController < ApplicationController
  def index
  end

  def fetch_gmail
    gmail = Gmail.new("h.akaishi.dev@gmail.com", "19940927")
    get_mail = gmail.inbox.emails(:all).last
    render 'index'
    return get_mail
  end

  def send_email_for_unity
    json = {
      :text => "test"
    }
    render :json => json
  end
end
