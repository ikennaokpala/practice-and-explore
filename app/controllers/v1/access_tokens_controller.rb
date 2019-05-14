class V1::AccessTokensController < V1::BaseController
  def create
    @user = User.find_by(params.permit(:email, :password))
    return head :unauthorized if @user.blank?
    render json: TokenizedUser.call(@user), 
         serializer: V1::TokenizedUserSerializer, status: :created
  end
  
  def destroy
    return head :not_found if payload.blank?
    session = JWTSessions::Session.new(refresh_by_access_allowed: true, payload: payload)
    session.login
    session.flush_by_access_payload
  end

  def update
    return head :not_found if params[:refresh_token].blank?
    credentials = JWTSessions::Session.new(payload: payload).refresh(params[:refresh_token])
    render json: { jwt: credentials[:access] }
  end
end
