class HomeController < ApplicationController
  before_filter :login_url
  before_filter :user_verification, :except => ["index", "login"]
  before_filter :check_if_user_has_liked_the_page, :except => ["login","like_gate"]
  #caches_page :index
  #caches_page :gallery
  
  def index
      if cookies[:acess_token]
        redirect_to "/like_gate"
      else
         redirect_to @oauth.url_for_oauth_code(:permissions => "email,publish_stream,user_likes")
      end  
  end

  def like_gate

  end
  
  def login
      code = params[:code]
      oauth_access_token = @oauth.get_access_token(code)
      user_facebook_id = get_user_id oauth_access_token
      user = User.find_by_fbid(user_facebook_id) if user_facebook_id
      if user.nil?
        user = User.create(:fbid => user_facebook_id, :oauth_access_token => oauth_access_token)
        cookies[:acess_token] = oauth_access_token
        cookies[:user_facebook_id] = user_facebook_id
        cookies[:user_id] = user.id
        cookies[:album_id] = user.album_id
      else
        cookies[:acess_token] = oauth_access_token
        cookies[:user_facebook_id] = user_facebook_id 
        cookies[:user_id] = user.id
        cookies[:album_id] = user.album_id
      end 
      redirect_to "/index"
  end

  def gallery
    @products = Product.all
  end

  def about_us
  end

  def privacy_policy
  end

  def ajax
    friend_row = get_friend_list cookies[:acess_token]
    if params[:page_number]
     @page_number = params[:page_number]
     start_number = params[:page_number].to_i*53
     end_number = start_number+53
     if end_number > friend_row.count
      @page_number = -1
     end  
     @friends = friend_row[start_number..end_number]
    else
      @friends = friend_row[0..53]
      @product_id = params[:product_id]
      @send = params[:send]
    end    
    respond_to do |format|
      format.js
      format.html
    end
  end
  
  def ajax_friend_filter
    
    if params[:filter_string].nil?
      @friends = get_friend_list cookies[:acess_token]
    else
      friends = get_friend_list cookies[:acess_token]
      @friends = []
      friends.each do |f|
        if f["name"].downcase.index(params[:filter_string].to_s.downcase)
          @friends << f
        end
      end  
    end
    respond_to do |format|
      format.js
      format.html
    end
  end
  
  def notify
    #render :text => params and return
    product_id = params[:product_id]
    send = params[:send]
    friends = params[:friends_ids]
    if send=="gift"
      #tag_friend product_id, send, friends
      send_notification  product_id, send, friends
    else  
      tag_friend product_id, send, friends
      
    end
    redirect_to "/gallery"
  end 

  # def tag
    # @friends = params[:friends_ids]
    # @friends.each do |friend|
      # tag_friend friend
    # end  
  # end

  private
    def get_user_id oauth_access_token
      graph = Koala::Facebook::API.new(oauth_access_token)
      user_info = graph.get_object("me")
      user_info.to_a[0][1]
    end  

  def get_friend_list oauth_access_token
    graph = Koala::Facebook::API.new(oauth_access_token)
    friends = graph.get_connections("me", "friends")
  end  

  def send_notification  production_id, send, friends
    graph = Koala::Facebook::API.new(cookies[:acess_token])
    product = Product.find(production_id)
     friends.each do |friend|
       begin
        share = Share.new(:friend_id => friend, :user_id => cookies[:user_id], :product_id => production_id)
        if share.save
          graph.put_connections(friend.to_i, "feed",
          :message => "Here is your Gift: #{product.name}. Please send me some too...",
          :picture => product.image.url,
          #:picture => "http://1.bp.blogspot.com/_BYX14125JUQ/SbH4xIQt_3I/AAAAAAAAJQs/erqvm4tJxtk/s400/Gorilla_Sign_Language.jpg",
          :link => REDIRECT_URL,
          :caption => "#{product.name}",
          :description => "#{product.description}"
          )
        end
      rescue Koala::Facebook::APIError => exc
        logger.error("Problems posting to Facebook Wall..."+self.inspect+" "+exc.message)
      end
      
       
       
    end   
    #code to send content as gift
  end
  
  def tag_friend product_id, send, friends
    tags = []
    friends.each do |f|
      begin
      tag = Tag.new(:friend_id => f, :user_id => cookies[:user_id], :product_id => product_id)  
      if tag.save
        tags << "@[#{f}:blah]"
      end
      rescue =>  e
      end  
    end
    final_tag = tags.join(",")
     product = Product.find(product_id)
     tags = {:to => 'me', :tag_text => "tag text test", :x => 10, :y => 10}
     graph = Koala::Facebook::API.new(cookies[:acess_token])
     # friends.each do |friend|
     begin
       user = User.find(cookies[:user_id])
       if user.album_id.nil?
         albuminfo = graph.put_object('me','albums', :name=>"Avon Gallery")
         album_id = albuminfo["id"] 
         user.album_id = album_id
         user.save
       else
         album_id = user.album_id
       end
      
      graph.put_picture(product.image.url, {:message => "#{final_tag}, Here is your Gift: #{product.name}. Please send me some too...", :tags => tags}, album_id)
      # graph.put_picture("http://1.bp.blogspot.com/_BYX14125JUQ/SbH4xIQt_3I/AAAAAAAAJQs/erqvm4tJxtk/s400/Gorilla_Sign_Language.jpg", {:message => "to #{final_tag} ", :tags => tags}, album_id)
      #tag = Tag.create(:friend_id => "100000104899797", :user_id => cookies[:user_id])
     rescue Koala::Facebook::APIError => exc
        logger.error("Problems posting to Facebook Wall..."+self.inspect+" "+exc.message)
     end
      
     # end
  end
    
end
