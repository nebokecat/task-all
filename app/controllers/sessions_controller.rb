class SessionsController < ActionController::Base
  include Session

  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in(user)
    else
      render json: { error: 'ログインに失敗しました' }, status: :unauthorized
    end
  end

  def destroy
  end
end
