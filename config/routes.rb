Rails.application.routes.draw do
  resources :chat_logs, only: [] do
    resources :entries, only: :create, controller: :chat_log_entries
  end
  resources :core_values
  resources :journal_entries do
    resource :analysis, only: :create, controller: :journal_entry_analysis
  end
  resources :relationships, except: :destroy do
    resources :summaries, only: %i[new create], controller: :relationship_summaries
    resource :ai_summary, only: :create, controller: :ai_relationship_summary
  end
  resource :questions, only: %i[create show]
  resources :questions, only: :destroy
  root "journal_entries#new"
end
