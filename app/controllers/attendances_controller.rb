class AttendancesController < ApplicationController
  before_action :set_user, only: [:edit_one_month, :update_one_month, :overtime]
  before_action :logged_in_user, only: [:update, :edit_one_month]
  before_action :admin_or_correct_user, only: [:update, :edit_one_month, :update_one_month]
  before_action :set_one_month, only: [:edit_one_month, :overtime]

  UPDATE_ERROR_MSG = "勤怠登録に失敗しました。やり直してください。"
  REPLY_ERROR_MSG = "残業申請返信に失敗しました。やり直してください。"

  def update
    @user = User.find(params[:user_id])
    @attendance = Attendance.find(params[:id])
    # 出勤時間が未登録であることを判定します。
    if @attendance.started_at.nil?
      if @attendance.update_attributes(started_at: Time.current.change(sec: 0))
        flash[:info] = "おはようございます！"
      else
        flash[:danger] = UPDATE_ERROR_MSG
      end
    elsif @attendance.finished_at.nil?
      if @attendance.update_attributes(finished_at: Time.current.change(sec: 0))
        flash[:info] = "お疲れ様でした。"
      else
        flash[:danger] = UPDATE_ERROR_MSG
      end
    end
    redirect_to @user
  end

#<!----------勤怠変更申請------------>
  def edit_one_month #<-----@user,@first_day,`last_day,one_month,@attendances
  end
  
  def request_edit_one_month
    edit_one_month_params.each do |id,item|
      attendance = Attendance.find(id)
      attendance.update_attributes(item)
      flash[:success] = "残業申請を行いました。"
    end
      redirect_to user_url(date: params[:date])
  end
  
  def reply_edit_one_month
    @user = User.joins(:attendances).group("user_id").where.not(attendances: {kintai_change_instructor_confirmation: "選択してください" })
    @attendance = Attendance.where.not(kintai_change_instructor_confirmation: "選択してください")
  end

  def update_one_month
      attendances_params.each do |id, item|
        attendance = Attendance.find(id)
        if params[:user][:attendances][id][:change] == "true"
        attendance.update_attributes(item)
        attendance.started_at = attendance.applying_started_at
        attendance.finished_at = attendance.applying_finished_at
        debugger
        end
      end
    flash[:success] = "勤怠変更を承認しました。"
    redirect_to user_url(date: params[:date])
  end
  
#<!----------残業申請------------>
  def overtime
    @day = Date.parse(params[:date])
    @youbi = %w(日 月 火 水 木 金 土)[@day.wday]
    @attendance = Attendance.find_by(worked_on:params[:date])
  end 

  def request_overtime
    @attendance = Attendance.find_by(worked_on:params[:date],user_id:params[:id])
    if @attendance.update_attributes(overtime_params)
      flash[:success] = "残業申請しました。"
      redirect_to user_url
    else
      flash[:danger] = "残業申請に失敗しました。"
      redirect_to user_url     
    end
  end
  
  def reply_overtime
    @user = User.joins(:attendances).group("user_id").where.not(attendances: {plan_finished_at: nil})
    @attendance = Attendance.where.not(plan_finished_at: nil)
  end
  
  def to_reply_overtime
    reply_overtime_params.each do |id,item|
      attendance = Attendance.find(id)
      if params[:user][:attendances][id][:change] == "true"
        attendance.update_attributes(item)
        flash[:success] = "残業申請のお知らせを変更しました。"
      end
    end
      redirect_to user_url(date: params[:date])
  end
  
#<!----------所属長承認申請------------>

  

  private
    # 1ヶ月分の勤怠情報を扱います。
    def attendances_params
      params.require(:user).permit(attendances: [:mark_kintai_change_instructor_confirmation])[:attendances]
    end
    
     # 残業申請情報を扱います。
    def overtime_params
      params.require(:attendance).permit(:plan_finished_at, :tomorrow, :business_processing_contents, :instructor_confirmation)
    end
    
    # 残業申請情報を扱います。
    def reply_overtime_params
      params.require(:user).permit(attendances: [:mark_instructor_confirmation])[:attendances]
    end
    
    # 残業申請情報を扱います。
    def edit_one_month_params
      params.require(:user).permit(attendances: [:applying_started_at, :applying_finished_at, :note, :kintai_change_instructor_confirmation])[:attendances]
    end
    
    # beforeフィルター

    # 管理権限者、または現在ログインしているユーザーを許可します。
    def admin_or_correct_user
      @user = User.find(params[:user_id]) if @user.blank?
      unless current_user?(@user) || current_user.admin?
        flash[:danger] = "編集権限がありません。"
        redirect_to(root_url)
      end  
    end
end