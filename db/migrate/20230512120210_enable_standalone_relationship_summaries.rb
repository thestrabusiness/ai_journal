class EnableStandaloneRelationshipSummaries < ActiveRecord::Migration[7.0]
  def up
    add_column :relationship_summaries, :title, :string
    rename_column :relationship_summaries, :content, :original_content

    RelationshipSummary.find_each do |summary|
      summary.update(content: summary.original_content)
    end

    JournalEntry.find_each do |entry|
      entry.relationship_summaries.update_all(created_at: entry.created_at)
    end

    remove_column :relationship_summaries, :original_content
  end

  def down
    add_column :relationship_summaries, :original_content, :text

    RelationshipSummary.find_each do |summary|
      summary.update(original_content: summary.content.to_plain_text)
    end

    rename_column :relationship_summaries, :original_content, :content
    remove_column :relationship_summaries, :title
  end
end
