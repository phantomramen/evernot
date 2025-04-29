class NotesController < ApplicationController
  before_action :require_authentication
  before_action :set_notebook, only: [:index, :edit, :update, :destroy, :new, :create]
  before_action :set_note, only: [:edit, :update, :destroy]

  def index
    @notes = if @notebook
      @notebook.notes.order(updated_at: :desc)
    else
      current_user.notes.order(updated_at: :desc)
    end

    respond_to do |format|
      format.html do
        if @notes.any?
          redirect_to edit_note_path(@notes.first, notebook_id: params[:notebook_id])
        else
          render :index
        end
      end
      format.turbo_stream do
        render turbo_stream: turbo_stream.update("notes_panel",
          partial: "shared/notes_panel",
          locals: { notes: @notes, current: nil, notebook: @notebook })
      end
    end
  end

  def new
    
    notebook_to_use = if params[:notebook_id]
      notebook = current_user.notebooks.find(params[:notebook_id])
      notebook
    else
      current_user.default_notebook
    end

    @note = notebook_to_use.notes.build(
      title: "Untitled",
      content: ""
    )
    
    if @note.save
      if params[:notebook_id]
        redirect_to edit_note_path(@note, notebook_id: notebook_to_use.id), notice: "Note created"
      else
        redirect_to edit_note_path(@note), notice: "Note created"
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def create
    notebook_to_use = @notebook || current_user.default_notebook
    @note = notebook_to_use.notes.build(note_params)
    
    if @note.save
      redirect_to edit_note_path(@note, notebook_id: notebook_to_use.id), notice: "Note created"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    respond_to do |format|
      format.html { render :edit }
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.update("notes_panel", 
            partial: "shared/notes_panel", 
            locals: { notes: @notebook ? @notebook.notes.order(created_at: :desc) : current_user.notes.order(created_at: :desc),
                     current: @note,
                     notebook: @notebook }),
          turbo_stream.update("main-content", 
            template: "notes/edit")
        ]
      end
    end
  end

  def update
    respond_to do |format|
      if @note.update(note_params)
        format.html { redirect_to edit_note_path(@note, notebook_id: params[:notebook_id]), notice: 'Note was successfully updated.' }
        format.json { render json: { status: 'success' }, status: :ok }
      else
        format.html { render :edit }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @note.destroy
    next_note = (@notebook&.notes || current_user.notes).order(updated_at: :desc).first
    
    if next_note
      if params[:notebook_id].present?
        redirect_to edit_note_path(next_note, notebook_id: params[:notebook_id]), notice: "Note deleted"
      else
        redirect_to edit_note_path(next_note), notice: "Note deleted"
      end
    else
      if params[:notebook_id].present?
        redirect_to notebook_path(@notebook), notice: "Note deleted"
      else
        redirect_to notes_path, notice: "Note deleted"
      end
    end
  end

  private

  def set_notebook
    @notebook = if params[:notebook_id]
      current_user.notebooks.find(params[:notebook_id])
    end
  end

  def set_note
    @note = if @notebook
      @notebook.notes.find(params[:id])
    else
      current_user.notes.find(params[:id])
    end
  end

  def note_params
    params.require(:note).permit(:title, :content)
  end
end
