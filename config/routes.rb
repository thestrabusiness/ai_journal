Rails.application.routes.draw do
  resources :journal_entries
  root 'journal_entries#new'
end
