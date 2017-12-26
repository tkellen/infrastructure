require File.expand_path(File.dirname(__FILE__) + '/lib/our365')

run DailyShare::App

DB.disconnect
