module DisplayTitle
  extend ActiveSupport::Concern

  def created_at_string
    created_at.strftime("%B %-d, %Y")
  end

  def display_title
    if persisted?
      title.present? ? title_with_date : created_at_string
    else
      Date.today.strftime("%B %-d, %Y")
    end
  end

  def title_with_date
    "#{created_at_string}: #{title}"
  end
end
