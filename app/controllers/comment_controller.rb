class CommentController < ApplicationController
  before_filter :store_location

  def index
    @comments = Comment.find(:all, :conditions => "parent_id is NULL", :order => 'created_at DESC')
  end

  def show
    @comment = Comment.find(params[:id])
  end

  def new_thread; end

  def create
    unless params[:content].blank?
      u = User.find_by_id(session[:user])
      c = Comment.new
      c.title = params[:title]
      c.content = params[:content]
      c.parent_id = params[:parent]
      c.user = u
      c.save
    end
    redirect_to :action => 'show', :id => params[:top] || c.id
  end
end
