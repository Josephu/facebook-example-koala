class OauthController < ApplicationController
	def login
		render :layout => "layouts/login"
	end

	def home
		@user_graph = Koala::Facebook::API.new(session[:access_token])
		pages = @user_graph.get_connections('me', 'friends')
		binding.pry
	end

	def index
		parse_facebook_cookies
		graph = Koala::Facebook::GraphAPI.new(@facebook_cookies["access_token"])
		@likes = graph.get_connections("me", "likes")
	end

	def logout
		session['access_token'] = nil
		redirect_to oauth_login_path
	end

	#before_filter :parse_facebook_cookies
	def parse_facebook_cookies
		@facebook_cookies = Koala::Facebook::OAuth.new.get_user_info_from_cookie(cookies)
		session["access_token"] = @facebook_cookies["access_token"]
	end
end