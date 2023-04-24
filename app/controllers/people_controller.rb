class PeopleController < ApplicationController
  def index
    @people = Person.includes(journal_entries: :relationship_summary_embeddings).all
  end

  def show
    @person = Person.includes(:journal_entries).find(params[:id])
    @summaries_for_journal_entries = @person
      .embeddings
      .includes(:journal_entry)
      .where(journal_entry_id: @person.journal_entries.pluck(:id))
      .order('journal_entries.created_at DESC')
  end
end
