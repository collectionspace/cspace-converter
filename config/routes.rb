Rails.application.routes.draw do
  root 'sites#index'
  get  'authorities',                to: 'authority_objects#index'
  get  'authorities/:id',            to: 'authority_objects#show', as: 'authority'
  post 'authorities/:id/ping',       to: 'authority_objects#ping'
  post 'authorities/:id/delete',     to: 'authority_objects#delete'
  post 'authorities/:id/ping',       to: 'authority_objects#ping'
  post 'authorities/:id/transfer',   to: 'authority_objects#transfer'
  post 'authorities/:id/update',     to: 'authority_objects#update'
  get 'batches',                     to: 'batches#index'
  delete 'batches/:id',              to: 'batches#destroy', as: :batch
  get 'cache',                       to: 'cache_objects#index'
  get 'connection',                  to: 'sites#connection', as: 'connection'
  get  'import',                     to: 'imports#new'
  post 'import',                     to: 'imports#create'
  get 'objects',                     to: 'data_objects#index'
  get 'objects/:id',                 to: 'data_objects#show', as: 'object'
  get  'procedures',                 to: 'procedure_objects#index'
  get  'procedures/:id',             to: 'procedure_objects#show', as: 'procedure'
  post 'procedures/:id/delete',      to: 'procedure_objects#delete'
  post 'procedures/:id/ping',        to: 'procedure_objects#ping'
  post 'procedures/:id/transfer',    to: 'procedure_objects#transfer'
  post 'procedures/:id/update',      to: 'procedure_objects#update'
  post 'nuke',                       to: 'sites#nuke', as: 'nuke'
  get  'relationships',              to: 'relationship_objects#index'
  get  'relationships/:id',          to: 'relationship_objects#show', as: 'relationship'
  post 'relationships/:id/ping',     to: 'relationship_objects#ping'
  post 'relationships/:id/delete',   to: 'relationship_objects#delete'
  post 'relationships/:id/ping',     to: 'relationship_objects#ping'
  post 'relationships/:id/transfer', to: 'relationship_objects#transfer'
  get  'transfer',                   to: 'transfers#new'
  post 'transfer',                   to: 'transfers#create'
  get  'vocabularies',               to: 'vocabulary_objects#index'
  get  'vocabularies/:id',           to: 'vocabulary_objects#show', as: 'vocabulary'
  post 'vocabularies/:id/ping',      to: 'vocabulary_objects#ping'
  post 'vocabularies/:id/delete',    to: 'vocabulary_objects#delete'
  post 'vocabularies/:id/ping',      to: 'vocabulary_objects#ping'
  post 'vocabularies/:id/transfer',  to: 'vocabulary_objects#transfer'
  post 'vocabularies/:id/update',    to: 'vocabulary_objects#update'
end
