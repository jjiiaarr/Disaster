class PostsController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  def index
    @hot = Post.all.order(comments_count: :desc).limit(3)
    @posts = Post.includes(:categories, :user).all.order(comments_count: :desc)
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user = current_user

    if Rails.env.development?
      @post.ip_address = Net::HTTP.get(URI.parse('http://checkip.amazonaws.com/')).squish
    else
      @post.ip_address = request.remote_ip
    end

    @post.country = Geocoder.search(@post.ip_address).first&.country
    @post.provider = Geocoder.search(@post.ip_address).first&.data['org']

    if @post.save
      redirect_to posts_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @post = Post.friendly.find(params[:id])
  end

  def edit
    authorize @post, :edit?, policy_class: PostPolicy
  end

  def update
    authorize @post, :update?, policy_class: PostPolicy

    if @post.update(post_params)
      redirect_to posts_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @post, :destroy?, policy_class: PostPolicy

    @post = Post.friendly.find(params[:id])
    if @post.comments.any?
      flash[:notice] = "Post has already comments. It can't be deleted."
      redirect_to posts_path
    else
      @post.destroy
      flash[:notice] = "Post is successfully deleted."
      redirect_to posts_path
    end
  end

  private

  def set_post
    @post = Post.friendly.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :content, :address, :image, category_ids: [])
  end
end
