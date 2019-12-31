Rails.application.routes.draw do
  resources :books do
    get 'destroyed', on: :collection
  end
  resources :versions, only: []  do
    patch 'rollback', on: :member
  end
end
