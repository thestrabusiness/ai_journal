class JournalEntriesController < AuthenticatedController
  before_action :set_journal_entry, only: %i[show edit update destroy]

  # GET /journal_entries
  def index
    @journal_entries = current_user.journal_entries.with_all_rich_text.order(created_at: :desc)
  end

  # GET /journal_entries/1
  def show; end

  # GET /journal_entries/new
  def new
    @journal_entry = current_user.journal_entries.new
  end

  # GET /journal_entries/1/edit
  def edit; end

  # POST /journal_entries
  def create
    @journal_entry = current_user.journal_entries.new(journal_entry_params)

    if @journal_entry.save
      redirect_to @journal_entry, notice: "Journal entry was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /journal_entries/1
  def update
    if @journal_entry.update(journal_entry_params)
      redirect_to @journal_entry, notice: "Journal entry was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /journal_entries/1
  def destroy
    @journal_entry.destroy
    redirect_to journal_entries_url, notice: "Journal entry was successfully destroyed."
  end

  private

  def set_journal_entry
    @journal_entry = current_user.journal_entries.find(params[:id])
  end

  def journal_entry_params
    params.require(:journal_entry).permit(:content, :title)
  end
end
