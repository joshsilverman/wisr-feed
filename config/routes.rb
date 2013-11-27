WisrFeed::Application.routes.draw do

  devise_for :users

  scope "api" do
    resources :posts do
      collection do
        post :create_or_update
      end
    end
    resources :users
    
  end
end
