class PeopleController < ApplicationController
  def index
    @people = find_people
    @query = query
  end

  def show
    @person = Person.includes(:journal_entries).find(params[:id])
    @summaries_for_journal_entries = @person
      .embeddings
      .includes(:journal_entry)
      .where(journal_entry_id: @person.journal_entries.pluck(:id))
      .order("journal_entries.created_at DESC")
  end

  private

  def find_people
    scope = Person.includes(journal_entries: :relationship_summary_embeddings).all
    return scope unless query.present?

    query_embedding_data = FetchEmbeddings.run(query)
    query_embedding = query_embedding_data.first[:embedding]
    scope.where_relationship_matches_query(query_embedding)
  end

  def search_params
    params[:search] || {}
  end

  def query
    search_params[:query]
  end
end
