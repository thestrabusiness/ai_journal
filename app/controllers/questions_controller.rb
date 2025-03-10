class QuestionsController < AuthenticatedController
  def show
    @questions = current_user.chat_logs.question.order("created_at DESC")
  end

  def create
    @question = current_user.chat_logs.new(kind: "question")
    @question.add_user_entry(question_params[:content], context)
    @question.save!

    respond_to do |format|
      format.html { redirect_to questions_path }
      format.turbo_stream
    end
  end

  def destroy
    @question = current_user.chat_logs.find(params[:id])
    @question.destroy!

    respond_to do |format|
      format.html { redirect_to questions_path }
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@question) }
    end
  end

  private

  def question_params
    params.require(:chat_log).permit(:content)
  end

  def context
    query_embedding = FetchEmbeddings.run(question_params[:content]).first[:embedding]
    entries = current_user.journal_entries.matching_query(query_embedding).first(5)
    context_string = "Here are some related journal entries:\n\n"
    entries.each do |entry|
      context_string += entry.display_title
      context_string += "\n\n"
      context_string += entry.content.to_plain_text
    end
    context_string
  end
end
