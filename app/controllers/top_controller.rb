class TopController < ApplicationController
  def index
  end
  
  def send_email_for_unity
    json = {
      :text => "test"
    }
    render :json => json
  end
end
