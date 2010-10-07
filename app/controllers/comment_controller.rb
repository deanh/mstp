class CommentController < ApplicationController
  def index
    @comments = Comment.find(:all, :conditions => "parent_id is NULL")
  end

  def show
    @comment = Comment.find(params[:id])
  end

  def create
    unless params[:content].blank? 
      c = Comment.new
      c.content = params[:content]
      c.parent_id = params[:parent]
      c.save
    end
    redirect_to :action => 'show', :id => params[:top]
  end
end
