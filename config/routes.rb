Rottenpotatoes::Application.routes.draw do
  resources :movies do
    match "similar" => "movies#similar", via: [:get, :post]
  end
end
