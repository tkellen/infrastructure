task :console do
  require './lib/goingslowly'
  require 'irb'
  require 'logger'
  require 'benchmark'
  include GS
  DB.logger = Logger.new($stdout)

  def bm(repetitions=100, &block)
    Benchmark.bmbm do |b|
      b.report {repetitions.times &block}
    end
    nil
  end
  ARGV.clear
  IRB.start
end
