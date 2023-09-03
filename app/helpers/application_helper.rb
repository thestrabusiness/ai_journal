module ApplicationHelper
  def question_text_class(index)
    if index.zero?
      "text-lg font-bold"
    else
      "flex-col p-spacing"
    end
  end
end
