class RelationshipsController < ApplicationController
  def index
    @relationships = find_relationships
    @query = query
  end

  def show
    @relationship = Relationship.includes(:journal_entries).find(params[:id])
    @summaries_for_journal_entries = @relationship
      .relationship_summaries
      .includes(:journal_entry)
      .where(journal_entry_id: @relationship.journal_entries.pluck(:id))
      .order("journal_entries.created_at DESC")
  end

  private

  def find_relationships
    scope = Relationship.includes(journal_entries: :relationship_summaries).all
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
