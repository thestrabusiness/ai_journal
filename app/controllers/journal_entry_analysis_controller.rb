class JournalEntryAnalysisController < AuthenticatedController
  def create
    @journal_entry = current_user.journal_entries.find(params[:journal_entry_id])
    @journal_entry.analyze!

    if @journal_entry.persisted?
      respond_to(&:turbo_stream)
    else
      head :unprocessable_entity
    end
  end
end
