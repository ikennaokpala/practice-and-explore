class V1::AccessTokensController < V1::BaseController
  def create
    @user = User.find_by(params.permit(:email, :password))
    render json: @user, serilizer: V1::UserSerializer, status: :created unless @user.blank?
  end
end
