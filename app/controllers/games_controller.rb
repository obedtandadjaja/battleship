class GamesController < ApplicationController
	skip_before_filter :verify_authenticity_token, :only => [:guess]

	def guess
		@user = current_user
		@game = Game.find(params[:game_id])
		if @user.game.include? @game
			
		else
			respond_to do |format|
				format.json { render json: @user }
			end
		end
	end

	def index
		@games = Game.where(is_completed: false)
	end

	def show
		@game = Game.find(params[:id])
	end

	def new
		@game = Game.new
	end

	def create
		@game = Game.create(num_players: params[:game][:num_players])
		if @game.save
			redirect_to :action => :index
		else
			flash[:notice] = "The form you submitted is invalid."
			redirect_to '/games/new'
		end
	end

	def destroy
		Game.find(params[:id]).destroy
      	redirect_to '/games'
	end

	def edit
		@game = Game.find(params[:id])
	end

	def update
		@game = Game.find(params[:id])
	    if @game.update_attributes(num_players: params[:game][:num_players])
	      	redirect_to :action => 'show', :id => @game
	  	else
	  		flash[:notice] = "The form you submitted is invalid."
			redirect_to :action => :edit, :id => @game
	    end
	end

end
