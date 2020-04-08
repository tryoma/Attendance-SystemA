class BasesController < ApplicationController
  before_action :set_base, only: [:edit, :update, :destroy]
  
  def index
    @bases = Base.all
  end
  
  def edit
  end
  
  def update
    if @base.update_attributes(base_params)
      flash[:success] = "拠点の更新に成功しました。"
      redirect_to bases_url
    else
      render :edit
    end
  end
  
  def new
    @base = Base.new
  end
  
  def create
    @base = Base.new(base_params)
    if @base.save
      flash[:success] = '拠点登録しました。'
      redirect_to bases_url
    else 
      render :new
    end
  end
  
  def destroy
    @base.destroy
    flash[:success] = "#{@base.base_name}のデータを削除しました。"
    redirect_to bases_url
  end
  
  private
  
  def base_params
    params.require(:base).permit(:base_number, :base_name, :base_type)
  end
  
  def set_base
    @base = Base.find(params[:id])
  end
    
end
