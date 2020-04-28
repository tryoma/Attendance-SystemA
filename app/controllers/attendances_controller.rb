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

  def edit_one_month
  end

  def update_one_month
    ActiveRecord::Base.transaction do # トランザクションを開始します。
      attendances_params.each do |id, item|
        attendance = Attendance.find(id)
        attendance.update_attributes!(item)
      end
    end
    flash[:success] = "1ヶ月分の勤怠情報を更新しました。"
    redirect_to user_url(date: params[:date])
  rescue ActiveRecord::RecordInvalid # トランザクションによるエラーの分岐です。
    flash[:danger] = "無効な入力データがあった為、更新をキャンセルしました。"
    redirect_to attendances_edit_one_month_user_url(date: params[:date])
  end
  
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
    @user = User.joins(:attendances).group("user_id").where.not(attendances: {plan_finished_at: nil})
    debugger
    @attendance = Attendance.find(params[:id])
    debugger
    if @attendance.update(reply_overtime_params)
      flash[:success] = "申請に返信しました。"
    else
      flash[:danger] = REPLY_ERROR_MSG
    end
    redirect_to user_url(current_user)
  end
  

  private
    # 1ヶ月分の勤怠情報を扱います。
    def attendances_params
      params.require(:user).permit(attendances: [:started_at, :finished_at, :note])[:attendances]
    end
    
     # 残業申請情報を扱います。
    def overtime_params
      params.require(:attendance).permit(:plan_finished_at, :tomorrow, :business_processing_contents, :instructor_confirmation)
    end
    
    # 残業申請情報を扱います。
    def reply_overtime_params
      params.require(:user).permit(attendances: [:mark_instructor_confirmation,:change])[:attendances]
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