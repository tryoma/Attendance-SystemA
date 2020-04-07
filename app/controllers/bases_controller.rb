class BasesController < ApplicationController
  def index
    @bases = Base.all
  end
  
  def new
    @base = Base.new
  end
  
  def create
    @base = Base.new(base_params)
    if @base.save
      flash[:success] = '拠点登録しました。'
      redirect_to 
    else
      render :new
    end
  end
  
  def base_params
    params.require(:base).permit(:base_number, :base_name, :base_type)
  end
end
