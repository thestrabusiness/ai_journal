class RelationshipsController < ApplicationController
  def index
    @relationships = find_relationships
    @query = query
  end

  def show
    @relationship = Relationship.find(params[:id])
    @relationship_summaries = @relationship
      .relationship_summaries
      .includes(:journal_entry)
      .order("created_at DESC")
  end

  private

  def find_relationships
    scope = Relationship.includes(:relationship_summaries)
    return scope.order("updated_at DESC") unless query.present?

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
