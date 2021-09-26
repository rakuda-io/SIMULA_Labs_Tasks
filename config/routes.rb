Rails.application.routes.draw do
  namespace 'api' do
    namespace 'v1' do
      get 'subjects', to: 'subjects#search'
    end
  end
end