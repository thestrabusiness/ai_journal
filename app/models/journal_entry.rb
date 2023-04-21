class JournalEntry < ApplicationRecord
  has_many :chat_logs, dependent: :destroy

  has_rich_text :content

  def analyze!
    new_analysis = FetchJournalEntryAnalysis.run(self)
    update(analysis: new_analysis)
  end

  def created_at_string
    created_at.strftime('%B %-d, %Y')
  end

  def display_title
    if persisted?
      title.present? ? title_with_date : created_at_string
    else
      Date.today.strftime('%B %-d, %Y')
    end
  end

  def title_with_date
    "#{created_at_string}: #{title}"
  end
end
