Rails.application.routes.draw do

  match 'angular/*path' => 'base#ng_renderer', via: [:get, :post, :put, :delete]

  match '*path' => 'base#index', via: [:get, :post, :put, :delete]
  root 'base#index'

end
