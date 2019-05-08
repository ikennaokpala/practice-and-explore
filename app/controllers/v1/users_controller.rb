class V1::UsersController < V1::BaseController
  def create
    @user = User.new(params.permit(:email, :name, :password))
    @user.save
    render json: @user, serializer: V1::UserSerializer, status: :created
  end  
end
