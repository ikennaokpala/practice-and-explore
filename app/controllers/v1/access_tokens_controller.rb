class V1::AccessTokensController < V1::BaseController
  def create
    @user = User.find_by(params.permit(:email, :password))      
    render json: TokenizedUser.call(@user), 
         serializer: V1::TokenizedUserSerializer, status: :created unless @user.blank?
  end
end
