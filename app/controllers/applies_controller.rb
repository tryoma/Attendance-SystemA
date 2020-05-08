class AppliesController < ApplicationController
  before_action :logged_in_user, only: [:update, :reply_month]
  
  def update
    @user = User.find(params[:user_id])
    @apply = Apply.find_or_initialize_by(user_id:params[:id],month: params[:date])
    if @apply.new_record?
      @apply.save!
    end
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
    @user = User.joins(:applies).group("user_id").where(applies: {month_to_who: "上長A"})
    @apply = Apply.where(month_to_who: "上長A")
  end
  
  def to_reply_month
   month_params.each do |id,item|
      apply = apply.find(id)
      if params[:user][:attendances][id][:change] == "true"
        attendance.update_attributes(item)
        flash[:success] = "残業申請のお知らせを変更しました。"
      end
    end
      redirect_to user_url(date: params[:date])
  end
  
    private
    # 月次申請のお知ら情報を扱います。
    def month_params
      params.require(:user).permit(applies: [:mark_month_instructor_confirmation])[:applies]
    end

    
end
