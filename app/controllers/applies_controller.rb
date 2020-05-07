class AppliesController < ApplicationController
  
  def update
    @user = User.find(params[:user_id])
    @apply = Apply.find_by(month: params[:id])
    # 出勤時間が未登録であることを判定します。
    if params[:month_instructor_confirmation] == "選択してください"
      flash[:danger] = "申請先を申請してください"
      redirect_to user_url
    else
      
      
      if @attendance.update_attributes(started_at: Time.current)
        flash[:info] = "おはようございます！"
      else
        flash[:danger] = "勤怠登録に失敗しました。やり直してください。"
      end
    end
    redirect_to @user
  end
end
