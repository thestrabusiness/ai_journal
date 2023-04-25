class Person < ApplicationRecord
  has_and_belongs_to_many :journal_entries
  has_many :embeddings, dependent: :destroy, class_name: 'RelationshipSummaryEmbedding'

  validates :name, presence: true, uniqueness: true

  def self.where_relationship_matches_query(query_embedding, similarity_threshold: 0.7)
    similarity_score_sql = Arel.sql("1 - (relationship_summary_embeddings.embedding <=> '#{query_embedding}')")
    left_joins(:embeddings)
      .select("people.*, MAX(#{similarity_score_sql}) AS similarity_score")
      .where("#{similarity_score_sql} > #{similarity_threshold}")
      .group('people.id')
      .order(Arel.sql('similarity_score DESC'))
  end
end
