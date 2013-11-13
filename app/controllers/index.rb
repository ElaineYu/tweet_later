get '/' do
  erb :landing
end

get '/sign_in' do
  # the `request_token` method is defined in `app/helpers/oauth.rb`
  redirect request_token.authorize_url
end

get '/sign_out' do
  session.clear
  redirect '/'
end

get '/auth' do
  # the `request_token` method is defined in `app/helpers/oauth.rb`
  @access_token = request_token.get_access_token(:oauth_verifier => params[:oauth_verifier])
  # our request token is only valid until we use it to get an access token, so let's delete it from our session
  session.delete(:request_token)

  # at this point in the code is where you'll need to create your user account and store the access token

  @user = User.find_by_username(@access_token.params[:screen_name])

  if @user.nil?
    @user = User.create(username: @access_token.params[:screen_name], oauth_token: @access_token.token, oauth_secret: @access_token.secret)
  end

  redirect to("/tweet/#{@user.id}")
end

get '/tweet/:user_id' do
  @user = User.find(params[:user_id])
  erb :index
end

post '/tweet' do
  @user = User.find(params[:user_id])

  twitter_client = Twitter::Client.new(:oauth_token => @user.oauth_token, :oauth_token_secret => @user.oauth_secret)
  twitter_client.update(params[:tweet])
end