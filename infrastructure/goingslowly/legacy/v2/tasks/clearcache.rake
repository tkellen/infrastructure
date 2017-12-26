task :clearcache do
  puts "Clearing memcached cache."
  `(sleep 2; echo flush_all; sleep 2; echo quit; ) | telnet 127.0.0.1 11211`
end
