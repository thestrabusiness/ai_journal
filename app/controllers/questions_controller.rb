class QuestionsController < ApplicationController
  def show
    @question = ChatLog.new
    @questions = ChatLog.question.order("created_at DESC")
  end

  def create
    @question = ChatLog.new(kind: "question")
    @question.add_user_entry(question_params[:content], context)
    @question.save!
    redirect_to questions_path
  end

  def destroy
    @question = ChatLog.find(params[:id])
    @question.destroy!
    redirect_to questions_path
  end

  private

  def question_params
    params.require(:chat_log).permit(:content)
  end

  def context
    query_embedding = FetchEmbeddings.run(question_params[:content]).first[:embedding]
    entries = JournalEntry.matching_query(query_embedding).first(5)
    context_string = "Here are some related journal entries:\n\n"
    entries.each do |entry|
      context_string += entry.display_title
      context_string += "\n\n"
      context_string += entry.content.to_plain_text
    end
    context_string += "\n\n"
    context_string
  end
end
