class AiRelationshipSummaryController < AuthenticatedController
  def create
    @relationship = current_user.relationships.find(params[:relationship_id])

    relationship_summary_params = GenerateAiRelationshipSummary
      .run(relationship: @relationship)

    @relationship_summary = @relationship
      .relationship_summaries
      .new(relationship_summary_params)

    if @relationship_summary.save
      redirect_to @relationship
    else
      render "relationships/show", status: :unprocessable_entity
    end
  end
end
