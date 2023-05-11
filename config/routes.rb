Rails.application.routes.draw do
  resources :chat_logs, only: [] do
    resources :entries, only: :create, controller: :chat_log_entries
  end
  resources :journal_entries do
    resource :analysis, only: :create, controller: :journal_entry_analysis
  end
  resources :relationships, except: :destroy
  root "journal_entries#new"
end
