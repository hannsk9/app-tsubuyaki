class MessagesController < ApplicationController
  before_action :require_user_logged_in
  
  def index
    # messageをしているユーザのidを取得し自分のidを削除することで、DM相手の一覧を表示
    @message_user_ids = Message.where(partner_id: current_user.id).or(Message.where(user_id: current_user.id)).distinct.pluck(:user_id)
    @message_user_ids.delete(current_user.id)
  end

  def show
    @partner_id = params[:partner_id]
    @messages = Message.where(user_id: current_user.id, partner_id: @partner_id).or(Message.where(user_id: @partner_id, partner_id: current_user.id)).order(created_at: :asc)
  end

  def create
    #@message = current_user.messages.build(message_params)
    message = Message.new(content: params[:content], user_id: params[:user_id], partner_id: params[:partner_id])
    if message.save
      flash[:success] = 'メッセージを送信しました。'
      redirect_back(fallback_location: root_path)
    else
      flash[:danger] = "メッセージの送信に失敗しました。"
      redirect_back(fallback_location: root_path)
    end
  end

  def destroy
    @message = Message.find(params[:id])
    @message.destroy
    flash[:success] = "メッセージを削除しました。"
    redirect_back(fallback_location: root_path)
  end
  
  private
  
  #def message_params
  #  params.require(:message).permit(:content, :partner_id)
  #end
end
