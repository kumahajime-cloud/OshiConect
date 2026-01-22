class OshisController < ApplicationController
  before_action :authenticate_user!
  before_action :set_profile

  def create
    @oshi = @user.oshis.build(oshi_params)

    if @oshi.save
      redirect_to profile_path(@user), notice: '推しを追加しました。'
    else
      redirect_to profile_path(@user), alert: @oshi.errors.full_messages.join(', ')
    end
  end

  def destroy
    @oshi = @user.oshis.find(params[:id])

    if @user == current_user
      @oshi.destroy
      redirect_to profile_path(@user), notice: '推しを削除しました。'
    else
      redirect_to root_path, alert: '権限がありません。'
    end
  end

  private

  def set_profile
    @user = User.find(params[:profile_id])
  end

  def oshi_params
    params.require(:oshi).permit(:name)
  end
end
