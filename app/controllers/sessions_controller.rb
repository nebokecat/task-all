class SessionsController < ActionController::Base
  include Session
  include ActionView::Layouts

  layout 'application'

  def new; end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user&.authenticate(params[:session][:password])
      log_in(user)
      redirect_to task_path(current_user)
    else
      render 'new'
    end
  end

  def destroy
    log_out
    redirect_to sessions_new_path
  end
end
