class V1::AccessTokensController < V1::BaseController
  def create
    @user = User.find_by(params.permit(:email, :password))      
    render json: TokenizedUser.call(@user), 
         serializer: V1::TokenizedUserSerializer, status: :created unless @user.blank?
  end
  
  def destroy
    return head :not_found if payload.blank?
    session = JWTSessions::Session.new(refresh_by_access_allowed: true, payload: payload)
    session.login
    session.flush_by_access_payload
  end
end
