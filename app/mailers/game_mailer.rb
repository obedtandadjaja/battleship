class GameMailer < ApplicationMailer

	def invite_game(email, user, game)
    	@email = email
    	@user = user
    	@game = game
    	mail :to => @email, :subject => "Battleship Game Invite!", :from => "no-reply@covenant-battleship.com"
  	end

end
