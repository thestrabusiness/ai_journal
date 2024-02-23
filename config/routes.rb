Rails.application.routes.draw do
  resources :chat_logs, only: [] do
    resources :entries, only: :create, controller: :chat_log_entries
  end
  resources :core_values
  resources :journal_entries do
    resource :analysis, only: :create, controller: :journal_entry_analysis
  end
  resource :pulse_check, only: %i[create show]
  resources :relationships, except: :destroy do
    resources :summaries, only: %i[new create], controller: :relationship_summaries
    resource :ai_summary, only: :create, controller: :ai_relationship_summary
  end
  resource :questions, only: %i[create show]
  resources :questions, only: :destroy

  constraints Clearance::Constraints::SignedIn.new do
    root "journal_entries#new", as: :signed_in_root
  end

  constraints Clearance::Constraints::SignedOut.new do
    root "clearance/sessions#new", as: :signed_out_root
  end
end
