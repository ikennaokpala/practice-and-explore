class V1::UsersController < V1::BaseController
  def create
    @user = User.new(params.permit(:email, :name, :password))
    if @user.save
      render json: TokenizedUser.call(@user), 
           serializer: V1::TokenizedUserSerializer, status: :created
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end  
end
