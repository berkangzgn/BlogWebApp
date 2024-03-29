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
    if @article.update(article_params)
      flash[:success] = "Article was updated"
      redirect_to article_path(@article)
    else
      flash[:danger] = "Article was not updated"
      render 'edit'
    end
  end

  def show; end

  def destroy
    @article.destroy
    if @article.destroy
      flash[:danger] = "Article was deleted"
      redirect_to articles_path
    else
      flash[:danger] = "Article wasn't deleted"
    end
  end

  private
  def set_article
    @article = Article.find(params[:id])
  end

  def article_params
    params.require(:article).permit(:title, :description)
  end
end