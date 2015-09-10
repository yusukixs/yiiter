class ArticlesController < ApplicationController
  # 一覧と詳細以外はログイン必須
  before_action :login_required, except: [:index, :show]
  
  before_action :set_article, only: [:show, :edit, :update, :destroy]

  # GET /articles
  # GET /articles.json
  def index
    if params[:user_id]
      @user = User.find(params[:user_id])
      @articles = @user.articles
    else
      @articles = Article.all
    end
    @articles = @articles.readable_for(current_user).order(released_at: :desc).page(params[:page])
  end

  # GET /articles/1
  # GET /articles/1.json
  def show
    @article = Article.readable_for(current_user).find(params[:id])
  end

  # GET /articles/new
  def new
    @article = Article.new
  end

  # GET /articles/1/edit
  def edit
  end

  # POST /articles
  # POST /articles.json
  def create
    @article = Article.new(article_params)

    respond_to do |format|
      if @article.save
        format.html { redirect_to @article, notice: 'Article was successfully created.' }
        format.json { render :show, status: :created, location: @article }
      else
        format.html { render :new }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /articles/1
  # PATCH/PUT /articles/1.json
  def update
    respond_to do |format|
      if @article.update(article_params)
        format.html { redirect_to @article, notice: 'Article was successfully updated.' }
        format.json { render :show, status: :ok, location: @article }
      else
        format.html { render :edit }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /articles/1
  # DELETE /articles/1.json
  def destroy
    @article.destroy
    respond_to do |format|
      format.html { redirect_to articles_url, notice: 'Article was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  # 投票
  def like
    @article = Article.published.find(params[:id])
    current_user.voted_articles << @article
    redirect_to @article, notice: "投票しました。"
  end
  
  # 投票を削除
  def unlike
    current_user.voted_articles.destroy(Article.find(params[:id]))
    redirect_to current_user, notice: "投票を削除しました。"
  end

  # 投票した記事一覧
  def voted
    @articles = current_user.voted_articles.published.order("votes.created_at DESC")
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_article
      @article = Article.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def article_params
      params.require(:article).permit(:title, :description)
    end
end
