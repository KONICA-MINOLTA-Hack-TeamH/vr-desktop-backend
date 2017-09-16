class TopController < ApplicationController
  def index
  end
  def feach_gmail
    format.html{ render :nothing => true }
    gmail = Gmail.new("h.akaishi.dev@gmail.com", "19940927")

    puts gmail.inbox.count
  end
  def send_email_for_unity
    json = {
      :text => "test"
    }
    render :json => json
  end
end
