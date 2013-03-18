# https://github.com/arsduo/koala/wiki/Graph-API
class OauthController < ApplicationController
	before_filter :parse_facebook_cookies, :except => [:login,:logout]
	def login
	end

	def friend
		@friend = @graph.get_object(params[:id])
	end

	def home
		@friends = @graph.get_connections('me', 'friends')
	end

	def index
		@likes = @graph.get_connections("me", "likes")
	end

	def logout
		session['access_token'] = nil
		redirect_to oauth_login_path
	end

private
	def parse_facebook_cookies
		# Check if first time login
		if session["access_token"] == nil
			facebook_cookies = Koala::Facebook::OAuth.new.get_user_info_from_cookie(cookies)
			session["access_token"] = facebook_cookies["access_token"]
		end
		@graph = Koala::Facebook::API.new(session[:access_token])
	end
end