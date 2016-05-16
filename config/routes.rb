Spree::Core::Engine.routes.draw do
  match '/payu_callback' => 'payu#notify', via: [:get, :post]
end
