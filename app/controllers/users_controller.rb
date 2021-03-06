class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :edit_basic_info, :update_basic_info, :log_check, :reference]
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy, :edit_basic_info, :update_basic_info, :attend_employees]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: [:destroy, :edit_basic_info, :update_basic_info, :attend_employees]
  before_action :set_one_month, only: [:show, :log_check, :reference]
  before_action :current_user_admin, only: :show
  
  

  def index
    @users = User.all
  end
  
  def import
    User.import(params[:file]) # fileはtmpに自動で一時保存される
    redirect_to users_url
  end

  def show
    @worked_sum = @attendances.where.not(started_at: nil).count
    @applies = @user.applies.where(user_id:params[:id]).where(month:@first_day)
    if current_user.name == "上長A" 
      @count1 = Apply.where(month_to_who:"上長A",mark_month_instructor_confirmation:"申請中").count
      @count2 = Attendance.where(kintai_to_who:"上長A",mark_kintai_change_instructor_confirmation:"申請中").count
      @count3 = Attendance.where(zangyou_to_who:"上長A",mark_instructor_confirmation:"申請中").count
    elsif current_user.name == "上長B" 
      @count1 = Apply.where(month_to_who:"上長B",mark_month_instructor_confirmation:"申請中").count
      @count2 = Attendance.where(kintai_to_who:"上長B",mark_kintai_change_instructor_confirmation:"申請中").count
      @count3 = Attendance.where(zangyou_to_who:"上長B",mark_instructor_confirmation:"申請中").count
    end
    
    respond_to do |format|
      format.html
      format.csv do |csv|
        send_attendances_csv(@attendances)
      end
    end
  end
  
  def send_attendances_csv(attendances)
    csv_data = CSV.generate do |csv|
      header = %w(日付 始業時間 終業時間)
      csv << header
      
      attendances.each do |attendance|
        values = [attendance.worked_on, (attendance.started_at.floor_to(15.minutes).strftime("%R") unless attendance.started_at.nil?) , (attendance.finished_at.floor_to(15.minutes).strftime("%R") unless attendance.finished_at.nil? )]
        csv << values
      end
    end
    send_data(csv_data, filename: "attendances.csv")
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
  
  # 出勤者��ージ
  def attend_employees
    @users = User.all.includes(:attendances)
    @day = Date.today
  end
  
  def log_check
    @attendances = @user.attendances.where(mark_kintai_change_instructor_confirmation: "承認")
    if params[:"date(1i)"].present?
      date = Date.new(params[:"date(1i)"].to_i, params[:"date(2i)"].to_i, params[:"date(3i)"].to_i)
      date_first_day = date
      date_end_day = date_first_day.end_of_month
      @attendances = @attendances.where( worked_on: [date_first_day..date_end_day])
    end
  end
  
  def reference
    @worked_sum = @attendances.where.not(started_at: nil).count
    @applies = @user.applies.where(user_id:params[:id]).where(month:@first_day)
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :affiliation, :password, :password_confirmation)
    end

    def user_info_params
      params.require(:user).permit(:name, :email, :affiliation, :basic_work_time, :designated_work_start_time, :designated_work_end_time, :uid, :employee_number )
    end

end