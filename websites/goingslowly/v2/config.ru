require File.expand_path(File.dirname(__FILE__) + '/lib/goingslowly')

run GS::App

DB.disconnect
