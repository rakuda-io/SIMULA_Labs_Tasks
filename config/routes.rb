Rails.application.routes.draw do
  namespace 'api' do
    namespace 'v1' do
      resources :subjects do
        collection do
          get 'search'
        end
      end
    end
  end
end