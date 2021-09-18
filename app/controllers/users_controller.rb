class UsersController < ApplicationController

  def index
    @users=User.all
    @book=Book.new
    @user=current_user
  end

  def show
    @user=User.find(params[:id])
    @books=@user.books
    @book=Book.new
    @current_entry=Entry.where(user_id: current_user.id)
    @another_entry=Entry.where(user_id: @user.id)
    unless @user.id == current_user.id
      @current_entry.each do |cu|
        @another_entry.each do |u|
          if cu.room_id == u.room_id
            @is_room=true
            @room_id=cu.room_id
          end
        end
      end
      unless @is_room
        @room=Room.new
        @entry=Entry.new
      end
    end
  end

  def edit
    @user=User.find(params[:id])
    if @user == current_user
      render :edit
    else
      redirect_to user_path(current_user)
    end
  end

  def update
    @user=User.find(params[:id])
    if @user.update(user_params)
      flash[:notice]="You have updated user successfully."
      redirect_to user_path(@user.id)
    else
      render :edit
    end
  end

  private
  def user_params
    params.require(:user).permit(:name,:profile_image,:introduction)
  end

end
