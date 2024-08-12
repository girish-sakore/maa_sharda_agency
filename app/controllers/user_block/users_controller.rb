module UserBlock
  class UsersController < ApplicationController
    # prepend_before_action :authorize_request
    before_action :set_user, only: %i[ show update destroy ]

    # GET /users
    def index
      @users = User.where('not TYPE=?', "UserBlock::Admin")
      metadata = { total_users: @users.count}
      render json: { metadata: metadata, users: serialize_users }, status: :ok
    end

    # GET /users/1
    def show
      render json: @user, status: :ok
    end

    # POST /users
    def create
      unless @current_user.is_admin?
        return permission_denied
      end

      case params[:type]
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
        render json: @user, status: :created
      else
        render json: @user.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /users/1
    def update
      if @user.update(user_params)
        render json: @user
      else
        render json: @user.errors, status: :unprocessable_entity
      end
    end

    # DELETE /users/1
    def destroy
      @user.destroy
    end

    private

      def set_user
        @user = User.find(params[:id])
      end

      def serialize_users
        users = []
          @users.each do |user|
            users << {
                        id: user.id,
                        name: user.name,
                        email: user.email,
                        type: user.type
                      }
          end
        users
      end

      # Only allow a list of trusted parameters through.
      def required_user_params
        params.permit(:email, :password, :name)
      end
  end
end