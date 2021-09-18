class RoomsController < ApplicationController

  def create
    @room=Room.create
    @current_entry=Entry.create(user_id: current_user.id, room_id: @room.id)
    @another_entry=Entry.create(room_params)
    redirect_to room_path(@room.id)
  end

  def show
    @room=Room.find(params[:id])
    @another_entry=@room.entries.find_by('user_id != ?', current_user.id)
    if Entry.where(user_id: current_user.id, room_id: @room.id).present?
      @messages=@room.messages.includes(:user)
      @message=Message.new
      @entries=@room.entries
    else
      redirect_back(fallback_location: root_path)
    end
  end
  
  private
  def room_params
    params.require(:entry).permit(:user_id, :room_id).merge(room_id: @room.id)
  end
  
end
