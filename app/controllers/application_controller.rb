class ApplicationController < ActionController::Base
  protect_from_forgery
  def login_url
  	@oauth = Koala::Facebook::OAuth.new(FACEBOOK_APP_ID, FACEBOOK_APP_SECRET, FACEBOOK_APP_CALLBACK_URL)
  end	
  
  def user_verification
    if cookies[:acess_token]
      begin
      graph = Koala::Facebook::API.new(cookies[:acess_token])
      user_info = graph.get_object("me")
      rescue => e
        #render :text =>  e.message and return
        cookies.delete :acess_token
      end
    else  
     redirect_to :root
    end
  end
  
  def check_if_user_has_liked_the_page
    if cookies[:user_facebook_id]
      graph = Koala::Facebook::API.new(cookies[:acess_token])
      my_query = "SELECT uid FROM page_fan WHERE uid= #{cookies[:user_facebook_id]}  AND page_id= #{PAGE_ID}"
      begin
        graph.fql_query(my_query).to_a[0]['uid']
         #render :text => my_query and return
      rescue => e
        # render :text => "You haven't liked the page yet.." and return
        redirect_to :like_gate
      end
    else  
       # redirect_to :root
    end
    
  end
end
