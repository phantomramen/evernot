class NotebooksController < ApplicationController
  include ActionView::RecordIdentifier
  before_action :require_authentication
  before_action :set_notebook, only: [:show, :edit, :update, :destroy, :set_default]
  before_action :set_notes_for_panel, only: [:show]

  def show
    @notes = @notebook.notes.order(updated_at: :desc)
    
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.update("notes_panel", 
          content: render_to_string(partial: "shared/notes_panel", 
                                  locals: { notes: @notes, 
                                          current: nil, 
                                          notebook: @notebook })
        )
      end
      format.html do
        if @notes.any?
          redirect_to edit_note_path(@notes.first, notebook_id: @notebook.id)
        else
          render :show
        end
      end
    end
  end

  def new
    @notebook = current_user.notebooks.build
  end

  def edit
  end

  def create
    notebook = current_user.notebooks.build(notebook_params)

    respond_to do |format|
      if notebook.save
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update("modal", ""),
            turbo_stream.replace("notebooks", partial: "notebooks/sidebar_list", locals: { notebooks: current_user.notebooks.order("LOWER(name)") })
          ]
        end
        format.html { redirect_to notebooks_path, notice: "Notebook created" }
      else
        format.turbo_stream do
          render turbo_stream: turbo_stream.update("modal", partial: "form", locals: { notebook: notebook }), status: :unprocessable_entity
        end
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    if @notebook.update(notebook_params)
      redirect_to notebooks_path, notice: "Notebook updated"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @notebook == current_user.default_notebook
      redirect_to root_path, alert: "Cannot delete the default notebook"
    else
      @notebook.destroy
      redirect_to root_path, notice: "Notebook deleted"
    end
  end

  def set_default
    current_user.update(default_notebook: @notebook)
    
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.replace("notebooks", partial: "notebooks/sidebar_list", locals: { notebooks: current_user.notebooks.order("LOWER(name)") })
        ]
      end
      format.html { redirect_to notebooks_path, notice: "Default notebook updated" }
    end
  end

  private

  def set_notebook
    @notebook = current_user.notebooks.find(params[:id])
  end

  def set_notes_for_panel
    @notes_for_panel = @notebook.notes.order(updated_at: :desc)
  end

  def notebook_params
    params.require(:notebook).permit(:name)
  end
end
