class AppliesController < ApplicationController
  before_action :logged_in_user, only: [:update, :reply_month, :to_reply_month]
  before_action :set_user, only: [:to_reply_month]
  before_action :logged_in_user, only: [:update, :reply_month, :to_reply_month]
  before_action :admin_or_correct_user, only: [:update]
  before_action :superior_user, only: [:reply_month, :to_reply_month]
  
  def update
    @user = User.find(params[:user_id])
    @apply = Apply.find_or_create_by(user_id:params[:id],month: params[:date])
    if params[:month_instructor_confirmation] == "選択してください"
      flash[:danger] = "申請先を申請してください"
      redirect_to user_url and return
    else
      @apply.update(month_to_who: params[:month_instructor_confirmation])
      @apply.update(mark_month_instructor_confirmation: "申請中")
      flash[:info] = "#{@apply.month.month}月の月次申請を行いました"
    end
    redirect_to user_url
  end
  
  def reply_month
    if current_user.name == "上長A"
      @user = User.joins(:applies).group(:id).where(applies: {month_to_who: "上長A"}).where(applies: {mark_month_instructor_confirmation: "申請中"}).order(nil)
      @apply = Apply.where(month_to_who: "上長A").where(mark_month_instructor_confirmation: "申請中").order(nil)
    elsif current_user.name == "上長B"
      @user = User.joins(:applies).group(:id).where(applies: {month_to_who: "上長B"}).where(applies: {mark_month_instructor_confirmation: "申請中"}).order(nil)
      @apply = Apply.where(month_to_who: "上長B").where(mark_month_instructor_confirmation: "申請中").order(nil)
    end
  end
  
  def to_reply_month
    month_params.each do |id,item|
      apply = Apply.find(id)
      if params[:user][:applies][id][:change] == "true"
        apply.update_attributes(item)
        flash[:success] = "変更にチェックある項目の月次申請のお知らせを変更しました。"
      elsif params[:user][:applies][id][:change] == "false"
        flash[:success] = "変更にチェックを入れないと変更されません。"
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
