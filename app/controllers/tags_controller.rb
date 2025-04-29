class TagsController < ApplicationController
  before_action :authenticate_user!

  def index
    @tags = current_user.tags
  end

  def show
    @tag = current_user.tags.find(params[:id])
    @notes = @tag.notes
  end

  def create
    @tag = current_user.tags.new(tag_params)
    if @tag.save
      redirect_to tags_path, notice: "Tag created"
    else
      render :index
    end
  end

  def destroy
    @tag = current_user.tags.find(params[:id])
    @tag.destroy
    redirect_to tags_path, notice: "Tag deleted"
  end

  private

  def tag_params
    params.require(:tag).permit(:name)
  end
end
