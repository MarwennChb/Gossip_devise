class GossipsController < ApplicationController

	def index
		unless signed_in?
			flash[:danger] = " HEY YOU MUST BE CONNECTED TO SEE ALL GOSSIPS"
			redirect_to new_user_session_path
		else
			@gossips = Gossip.all
		end
	end

	def new
		@gossips = Gossip.new
	end

	def create
		@gossips = Gossip.new(gossips_params)
		@gossips.content = gossips_params[:content]
		@gossips.user_id = current_user.id
		if @gossips.save
			flash[:success] = "Gossip created!"
			redirect_to gossips_path
		else
			render 'new'
		end
	end

	def edit
		@gossips = Gossip.find(params[:id])
		@creator = @gossips.user_id
		unless signed_in? && @creator == current_user.id
			flash[:danger] = "You cannot modify someone else's gossip"
			redirect_to root_path
		end
	end

	def update
		@gossips = Gossip.find(params[:id])
		if @gossips.update(gossips_params)
			redirect_to gossips_path
		else 
			render 'edit'
		end

	end

	def show
		@gossips = Gossip.find(params[:id])
		unless signed_in?
			flash[:danger] = "You need to log in to see these"
			redirect_to root_path
		end
	end

	def destroy
		@gossips = Gossip.find(params[:id])
		@creator = @gossips.user_id
		unless signed_in? && @creator == current_user.id
			flash[:danger] = "You cannot destroy someone else's gossip"
		else

			if @gossips.destroy
				redirect_to root_path
				flash[:success] = 'Gossip deleted'
			end
		end
	end


	private
	def gossips_params
		params.require(:gossips).permit(:content)

	end
end