WisrFeed::Application.routes.draw do
  scope "api" do
    resources :posts
  end
end
