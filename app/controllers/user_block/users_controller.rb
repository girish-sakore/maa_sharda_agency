module UserBlock
  class UsersController < ApplicationController
    include UserHelper
    before_action :set_user, only: %i[ show update destroy ]
    # skip_before_action :authorize_request, only: :index

    def index
      @users = UserBlock::User.where('not TYPE=?', "UserBlock::Admin")
      metadata = { total_users: @users.count}
      render json: { metadata: metadata, users: serialize_users(@users) }, status: :ok
    end

    def show
      render json: serialize_user(@user), status: :ok
    end

    def create
      unless @current_user.is_admin?
        return permission_denied
      end

      case params[:type].downcase
      when "admin"
        @user = Admin.new(required_user_params)
      when "caller"
        @user = Caller.new(required_user_params)
      when "executive"
        @user = Executive.new(required_user_params)
      else
        @user = User.new(required_user_params)
      end

      if @user.save
        render json: { message: "Yay! User added.", user:serialize_user(@user) }, status: :created
      else
        render json: { message: "Uh..Oh! Please check the fields again...", errors: @user.errors }, status: :unprocessable_entity
      end
    end

    def update
      if @user.update(required_user_params)
        render json: { message: "Yay! User updated.", user: serialize_user(@user) }
      else
        render json: { message: "Uh..Oh! Please check the fields again...", errors: @user.errors}, status: :unprocessable_entity
      end
    end

    def destroy
      @user.destroy
      render json: { message: "User deleted...", user: serialize_user(@user)}, status: :ok
    end

    private

    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def required_user_params
      params.permit(:email, :password, :name, :mobile_number, :alt_mobile_number, :status)
    end
  end
end