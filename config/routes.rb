Rails.application.routes.draw do
  resources :journal_entries
  resources :chat_logs, only: [] do
    resources :entries, only: :create, controller: :chat_log_entries
  end
  root 'journal_entries#new'
end
