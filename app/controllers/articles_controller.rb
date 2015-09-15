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
    
    @comments = Comment.find_by_sql(["SELECT *
                  FROM comments
                  INNER JOIN (users INNER JOIN user_images ON users.id = user_images.user_id ) ON comments.user_id = users.id
                  WHERE comments.article_id = ?
                  ORDER BY comments.created_at DESC", params[:id]])
  end

  # GET /articles/new
  def new
    @article = Article.new(released_at: Time.current)
  end

  # GET /articles/1/edit
  def edit
    @article = Article.readable_for(current_user).find(params[:id])
  end

  # POST /articles
  # POST /articles.json
  def create
    @article = Article.new(article_params)
    @article.author = current_user
    if @article.save
      redirect_to @article, notice: "記事を作成しました。"
    else
      render "new"
    end
  end

  # PATCH/PUT /articles/1
  # PATCH/PUT /articles/1.json
  def update
    @article = Article.readable_for(current_user).find(params[:id])
    @article.assign_attributes(article_params)
    if @article.save
      redirect_to @article, notice: "記事を更新しました。"
    else
      render "edit"
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
    redirect_to Article.find(params[:id]), notice: "投票を削除しました。"
  end

  # 投票した記事一覧
  def voted
    @articles = current_user.voted_articles.published.order("votes.created_at DESC")
  end
  
  # コメントした記事一覧
  def commented
    @articles = current_user.commented_articles.published.order("comments.created_at DESC")
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_article
      @article = Article.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def article_params
      params.require(:article).permit(:title, :description, :released_at, :status)
    end
    
    def send_image
      if @comment.image.present?
        send_data @comment.image.data, type: @comment.image.content_type, disposition: "inline"
      else
        raise NotFound
      end
    end
end
