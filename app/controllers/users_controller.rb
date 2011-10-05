class UsersController < ApplicationController
  # Make sure the user is logged in to access these actions.
  before_filter :login_required, :except => [:login,:new,:create,:show]
  before_filter :yours_required || :admin_required, :only => [:edit, :update]
  before_filter :admin_required, :except => [:login,:logout,:new,:create,:show,:edit,:update]

  def login
    # Make sure the authentication parameters were provided.
    if params.has_key?(:username) and params.has_key?(:rpassword)
      # Authenticate using the posted credentials.
      user = User.authenticate params[:username], params[:rpassword]
      # Credentials were valid if the user var is not nil.
      if user != nil
        # Save the ID of the authenticated user.
        session[:id] = user.id
        # Now that the user is logged in, decide where to send them.
        session.has_key?(:return_to) ? redirect_to(session[:return_to]) : redirect_to("/")
      else
        flash[:error] = "The credentials you provided were invalid."
        redirect_to "/login"
      end
    end
  end

  def logout
    reset_session
    redirect_to "/"
  end

  def reports
    @users = User.all
    render 'users/user_report'
  end

  def details
    @user = User.find(params[:id])
    render 'users/ind_report'
  end

  # GET /users
  # GET /users.xml
  def index
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end

  # GET /users/1
  # GET /users/1.xml
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/new
  # GET /users/new.xml
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.xml
  def create
    @user = User.new(params[:user])
    @user.current_userid = @current_user.id if ! @current_user.nil?
    if @user.save
      if ! @current_user.nil?
        redirect_to @user, :notice => 'User was successfully created.'
      else
        redirect_to '/login', :notice => 'Your account was successfully created. You can now login.'
      end
    else
      render :action => "new"
    end
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    @user = User.find(params[:id])
    @user.current_userid = @current_user.id if ! @current_user.nil?

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to(@user, :notice => 'User was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @user = User.find(params[:id])

    @posts = Post.all
    @posts.each do |post|
      if(post.user_id == @user.id)
        post.destroy
      end
    end

    @votes = Vote.all
    @votes.each do |vote|
      if(vote.user_id == @user.id)
        vote.destroy
      end
    end

    @user.destroy

    respond_to do |format|
      format.html { redirect_to(users_url) }
      format.xml  { head :ok }
    end
  end



end
