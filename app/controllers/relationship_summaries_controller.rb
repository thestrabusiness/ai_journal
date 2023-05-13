class RelationshipSummariesController < ApplicationController
  def new
    @relationship = Relationship.find(params[:relationship_id])
    @relationship_summary = RelationshipSummary.new
  end

  def create
    @relationship = Relationship.find(params[:relationship_id])
    @relationship_summary = @relationship
      .relationship_summaries
      .new(relationship_summary_params)

    if @relationship_summary.save
      redirect_to @relationship_summary.relationship
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def relationship_summary_params
    params
      .require(:relationship_summary)
      .permit(
        :title,
        :content,
        :embedding
      )
  end
end
