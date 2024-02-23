class ChatLogEntriesController < AuthenticatedController
  def create
    @chat_log = current_user.chat_logs.find(params[:chat_log_id])
    @chat_log.add_user_entry(params[:chat_log][:content])

    if @chat_log.save
      respond_to(&:turbo_stream)
    else
      head :unprocessable_entity
    end
  end
end
