WisrFeed::Application.routes.draw do

  devise_for :users

  scope "api" do
    resources :posts
    resources :users
    
  end
end
