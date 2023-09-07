class UsersController < ApplicationController
    def index 
        @users = User.all
    end

    # def show
    #     @user = current_user
    #     @product = @user.products.first
    # end
    
    # def new 
    #     @user = User.new
    # end

    # def create
    #     @user = User.new(user_params)
    #     if @user.save
    #         redirect_to root_path, notice: 'Account created successfully'
    #     else
    #         render :new
    #     end
    # end
    
    # def edit
    #     @user = User.find(params[:id])
    # end
    
    # def update
    #     @user = User.find(params[:id])
    
    #     if @user.update(user_params)
    #         redirect_to @user
    #     else
    #         render :edit, status: :unprocessable_entity
    #     end
    # end
    
    # def destroy
    #     @user = current_user
    #     @user.destroy
    #     redirect_to users_path, status: :see_other
    # end
    
    # private
    
    # def user_params
    #     params.require(:user).permit(:name, :phone, :email, :password, :password_confirmation)
    # end
end
