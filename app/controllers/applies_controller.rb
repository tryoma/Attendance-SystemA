class AppliesController < ApplicationController
  
  def update
    @user = User.find(params[:user_id])
    @apply = Apply.find_or_initialize_by(month: params[:date]) 
    # 出勤時間が未登録であることを判定します。
    if params[:month_instructor_confirmation] == "選択してください"
      flash[:danger] = "申請先を申請してください"
      redirect_to user_url
    else
      @apply.update(month_to_who: params[:month_instructor_confirmation])
      flash[:info] = "#{@apply.month.month}月の月次申請を行いました"
    end
    redirect_to user_url
  end
  
  def reply_month
  end
    
end
