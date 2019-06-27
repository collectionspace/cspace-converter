# Require the DEFAULT module
Dir["#{Rails.root.join('lib', 'collectionspace', 'converter', 'default')}/*.rb"].each do |lib|
  require lib
end

# Require everything else
Dir["#{Rails.root.join('lib', 'collectionspace')}/**/*.rb"].each do |lib|
  require lib
end

AuthCache::FileLoader.new(AuthCache.auth_cache_vocabularies_file).setup
