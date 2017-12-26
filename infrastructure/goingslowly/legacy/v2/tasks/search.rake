task :searchup do
  sh "mkdir search"
  sh "indexer --config config/sphinx.conf --all"
  sh "searchd --config config/sphinx.conf"
end

task :searchdown do
  sh "searchd --config config/sphinx.conf --stop"
end

task :searchindex do
  sh "indexer --config config/sphinx.conf --all --rotate"
end
