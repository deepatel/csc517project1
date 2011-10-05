 class PostsController < ApplicationController
  # Make sure the user is logged in to access these actions.
  before_filter :login_required, :except => [:all,:search,:top]
  before_filter :owner_required || :admin_required, :only => [:edit, :update]
  before_filter :admin_required, :except => [:all,:search,:top,:new,:create,:show, :edit, :update,:new_reply]


  def all
    @posts = Post.not_replies
    render 'posts/post_display'
  end

  def search
    if params.has_key?(:searchtype) and params.has_key?(:searchquery)
      @posts = Post.search params[:searchtype], params[:searchquery]
      render 'posts/post_display'
    else
      flash[:error] = "To search, you must provide the type and what you want to search for."
      redirect_to :action => :top
    end
  end

  def top
    @posts = Post.top
    render 'posts/post_display'
  end

  def new_reply
    @post = Post.new
    render :new
  end

  # GET /posts
  # GET /posts.xml
  def index
    @posts = Post.not_replies

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @posts }
    end
  end

  # GET /posts/1
  # GET /posts/1.xml
  def show
    @post = Post.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @post }
    end
  end

  # GET /posts/new
  # GET /posts/new.xml
  def new
    @post = Post.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @post }
    end
  end

  # GET /posts/1/edit
  def edit
    @post = Post.find(params[:id])
  end

  # POST /posts
  # POST /posts.xml
  def create
    @post = Post.new(params[:post])
    if @post.save
      redirect_to '/', :notice => 'Post was successfully created.'
    else
      render :action => "new"
    end
    return
  end

  # PUT /posts/1
  # PUT /posts/1.xml
  def update
    @post = Post.find(params[:id])

    respond_to do |format|
      if @post.update_attributes(params[:post])
        format.html { redirect_to(@post, :notice => 'Post was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @post.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.xml
  def destroy
    @post = Post.find(params[:id])

    @votes = Vote.all
    @votes.each do |vote|
      if(vote.post_id == @post.id)
        vote.destroy
      end
    end

    @post.destroy

    respond_to do |format|
      format.html { redirect_to(posts_url) }
      format.xml  { head :ok }
    end
  end
end
