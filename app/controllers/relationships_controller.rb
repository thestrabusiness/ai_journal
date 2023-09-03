class RelationshipsController < ApplicationController
  def index
    @relationships = fetch_relationships
    @query = query
  end

  def show
    @relationship = Relationship.find(params[:id])
    @relationship_summaries = @relationship
      .relationship_summaries
      .with_all_rich_text
      .includes(:journal_entry)
      .order("relationship_summaries.created_at DESC")
  end

  private

  def fetch_relationships
    scope = Relationship.includes(:relationship_summaries)

    if query.present?
      scope.where("name ILIKE ?", "%#{query}%")
    else
      scope.order("updated_at DESC")
    end
  end

  def search_params
    params[:search] || {}
  end

  def query
    search_params[:query]
  end
end
