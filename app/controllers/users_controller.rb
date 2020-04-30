class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :attend_employees,  :edit_basic_info, :update_basic_info]
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy, :edit_basic_info, :update_basic_info, :attend_employees]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: [:destroy, :edit_basic_info, :update_basic_info, :attend_employees]
  before_action :set_one_month, only: :show

  def index
    @users = User.all
  end
  
  def import
    # fileはtmpに自動で一時保存される
    User.import(params[:file])
    redirect_to users_url
  end

  def show
    @worked_sum = @attendances.where.not(started_at: nil).count
    @count1 = 1
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = '新規作成に成功しました。'
      redirect_to @user
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "ユーザー情報を更新しました。"
      redirect_to @user
    else
      render :edit      
    end
  end

  def destroy
    @user.destroy
    flash[:success] = "#{@user.name}のデータを削除しました。"
    redirect_to users_url
  end

  def edit_basic_info
  end

  def update_basic_info
    if @user.update_attributes(user_info_params)
      flash[:success] = "基本情報を更新しました。"
    else
      flash[:danger] = "更新が失敗しました。<br>" + @user.errors.full_messages.join("<br>")
    end
      redirect_to users_url
  end
  
  def attend_employees
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :affiliation, :password, :password_confirmation)
    end

    def user_info_params
      params.require(:user).permit(:name, :email, :affiliation, :basic_work_time, :designated_work_start_time, :designated_work_end_time, :uid, :employee_number )
    end

end