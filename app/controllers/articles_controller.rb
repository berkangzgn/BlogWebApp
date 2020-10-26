class ArticlesController < ApplicationController
  before_action :set_article, only: [:edit, :update, :show, :destroy]

  def index
    @articles = Article.paginate(page: params[:page], per_page: 5)
  end

  def new
    @article = Article.new
  end

  def edit; end

  def create
    @article = Article.new(article_params)
    @article.user = current_user
    if @article.save
      flash[:success] = "Article was successfully created"
      redirect_to article_path(@article)
    else
      render :new; end
  end

  def update
    if current_user == @article.user
      if @article.update(article_params)
        flash[:success] = "Article was updated"
        redirect_to article_path(@article)
      else
        flash[:danger] = "Article was not updated"
        render :edit; end
    else
      flash[:danger] = "You cannot update this user because you didn't create this article."
      redirect_to articles_path
    end
  end

  def show; end

  def destroy
    if current_user == @article.user
      @article.destroy
      flash[:danger] = "Article was deleted"
    else
      flash[:danger] = "You cannot update this user because you didn't create this article."
    end
    redirect_to articles_path
  end

  private
  def set_article
    @article = Article.find(params[:id])
  end

  def article_params
    params.require(:article).permit(:title, :description)
  end
end