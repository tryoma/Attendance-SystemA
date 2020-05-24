class AttendancesController < ApplicationController
  before_action :set_user, only: [:edit_one_month, :update_one_month, :overtime]
  before_action :logged_in_user, only: [:update, :edit_one_month, :request_edit_one_month, :reply_edit_one_month, :update_one_month, :overtime, :request_overtime, :reply_overtime, :to_reply_overtime]
  before_action :admin_or_correct_user, only: [:update, :edit_one_month, :update_one_month]
  before_action :set_one_month, only: [:edit_one_month, :overtime]
  before_action :superior_user, only: [:reply_edit_one_month, :update_one_month, :reply_overtime, :to_reply_overtime]
  
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
    ActiveRecord::Base.transaction do # トランザクションを開始します。
      edit_one_month_params.each do |id,item|
        attendance = Attendance.find(id)
        if params[:user][:attendances][id][:kintai_change_instructor_confirmation].present?
          attendance.update_attributes!(item)
          attendance.update(kintai_to_who: params[:user][:attendances][id][:kintai_change_instructor_confirmation])
          if attendance.mark_kintai_change_instructor_confirmation == "承認"
            attendance.update(mark_kintai_change_instructor_confirmation: "申請中")
          elsif attendance.mark_kintai_change_instructor_confirmation == "否認"
            attendance.update(mark_kintai_change_instructor_confirmation: "申請中")
          end
        end
      end
    end
    flash[:success] = "勤怠変更申請を行いました。"
    redirect_to user_url(date: params[:date])
  rescue ActiveRecord::RecordInvalid # トランザクションによるエラーの分岐です。
    flash[:danger] = "無効な入力データがあった為、更新をキャンセルしました。"
    redirect_to attendances_edit_one_month_user_url(date: params[:date])
  end
  
  def reply_edit_one_month
    if current_user.name == "上長A"
      @user = User.joins(:attendances).group(:id).where(attendances: {kintai_to_who: "上長A"}).where(attendances: {mark_kintai_change_instructor_confirmation: "申請中"}).order(nil)
      @attendance = Attendance.where(attendances: {kintai_to_who: "上長A"}).where(attendances: {mark_kintai_change_instructor_confirmation: "申請中"}).order(nil)
    elsif current_user.name == "上長B"
      @user = User.joins(:attendances).group(:id).where(attendances: {kintai_to_who: "上長B"}).where(attendances: {mark_kintai_change_instructor_confirmation: "申請中"}).order(nil)
      @attendance = Attendance.where(attendances: {kintai_to_who: "上長B"}).where(attendances: {mark_kintai_change_instructor_confirmation: "申請中"}).order(nil)
    end
  end

  def update_one_month
      attendances_params.each do |id, item|
        attendance = Attendance.find(id)
        if params[:user][:attendances][id][:change] == "true"
          if params[:user][:attendances][id][:mark_kintai_change_instructor_confirmation] == "承認"
            attendance.update_attributes(item)
            attendance.update(first_started_at: attendance.started_at, first_finished_at: attendance.finished_at)
            attendance.update(started_at: attendance.applying_started_at, finished_at: attendance.applying_finished_at)
            attendance.update(approval: Date.today )
          elsif params[:user][:attendances][id][:mark_kintai_change_instructor_confirmation] == "否認"
            attendance.update_attributes(item)
          end
        end
      end
    flash[:success] = "変更にチェックのあった申請の勤怠変更をしました。"
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
    if params[:attendance][:plan_finished_at].blank? || params[:attendance][:instructor_confirmation] == "選択してください"
      flash[:danger] = "申請先または申請時間を入力してください"
      redirect_to user_url and return  
    else  
      @attendance.update_attributes(overtime_params)
      @attendance.update_attributes(zangyou_to_who:params[:attendance][:instructor_confirmation])
      if @attendance.mark_instructor_confirmation != "申請中"
        @attendance.update_attributes(mark_instructor_confirmation: "申請中")
      end
      if @attendance.tomorrow != true
        @attendance.update_attributes(tomorrow: false )
      end
      flash[:success] = "残業申請しました。"
      redirect_to user_url
    end
  end
  
  def reply_overtime
    if current_user.name == "上長A"
      @user = User.joins(:attendances).group(:id).where.not(attendances: {plan_finished_at: nil}).where(attendances: {zangyou_to_who: "上長A"}).where.not(attendances: {mark_instructor_confirmation: "承認"}).where.not(attendances: {mark_instructor_confirmation: "否認"}).order(nil)
      @attendances = Attendance.where.not(plan_finished_at: nil).where(zangyou_to_who:"上長A").where.not(mark_instructor_confirmation: "承認").where.not(mark_instructor_confirmation: "否認").order(nil)
    elsif current_user.name == "上長B"
      @user = User.joins(:attendances).group(:id).where.not(attendances: {plan_finished_at: nil}).where(attendances: {zangyou_to_who: "上長B"}).where.not(attendances: {mark_instructor_confirmation: "承認"}).where.not(attendances: {mark_instructor_confirmation: "否認"}).order(nil)
      @attendances = Attendance.where.not(plan_finished_at: nil).where(zangyou_to_who:"上長B").where.not(mark_instructor_confirmation: "承認").where.not(mark_instructor_confirmation: "否認").order(nil)
    end
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

  

  
  
  
#<!----------勤怠確認参照------------>
  
  
  
  
  private
    # 1ヶ月分の勤怠情報を扱います。
    def attendances_params
      params.require(:user).permit(attendances: [:mark_kintai_change_instructor_confirmation])[:attendances]
    end
    
     # 残業申請情報を扱います。
    def overtime_params
      params.require(:attendance).permit(:plan_finished_at, :tomorrow, :business_processing_contents)
    end
    
    # 残業申請情報を扱います。
    def reply_overtime_params
      params.require(:user).permit(attendances: [:mark_instructor_confirmation])[:attendances]
    end
    
    # 残業申請情報を扱います。
    def edit_one_month_params
      params.require(:user).permit(attendances: [:applying_started_at, :applying_finished_at, :note, :kintai_tomorrow])[:attendances]
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