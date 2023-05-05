class RenameRelationshipSummaryEmbeddings < ActiveRecord::Migration[7.0]
  def change
    rename_table :relationship_summary_embeddings, :relationship_summaries
  end
end
