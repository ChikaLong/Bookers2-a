class BooksController < ApplicationController

  def create
    @book=Book.new(book_params)
    @book.user_id=current_user.id
    if @book.save
      flash[:notice]="You have created book successfully."
      redirect_to book_path(@book.id)
    else
      @books=Book.all
      @user=current_user
      render :index
    end
  end

  def index
    @book=Book.new
    @user=current_user
    to=Time.current.at_end_of_day
    from=(to-6.day).at_beginning_of_day
    @books=Book.includes(:favorited_users).sort {|a,b| b.favorited_users.includes(:favorites).where(created_at: from...to).size <=> a.favorited_users.includes(:favorites).where(created_at: from...to).size}
  end

  def show
    @book=Book.find(params[:id])
    @newbook=Book.new
    @user=@book.user
    @book_comment=BookComment.new
  end

  def edit
    @book=Book.find(params[:id])
    if @book.user == current_user
      render :edit
    else
      redirect_to books_path
    end
  end

  def update
    @book=Book.find(params[:id])
    @book.user_id=current_user.id
    if @book.update(book_params)
      flash[:notice]="You have updated book successfully."
      redirect_to book_path(@book)
    else
      render :edit
    end
  end

  def destroy
    @book=Book.find(params[:id])
    @book.destroy
    redirect_to books_path
  end

  private
  def book_params
    params.require(:book).permit(:title,:body)
  end

end
