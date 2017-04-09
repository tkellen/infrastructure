require 'aws/s3'

module GS
  class S3

    ##
    # Open a connection on initialization.
    #
    def initialize
      AWS::S3::Base.establish_connection!(
       :access_key_id => AUTH['aws']['access_key_id'],
       :secret_access_key => AUTH['aws']['secret_access_key']
      )
    end

    ##
    # Save a file blob to S3.
    #
    def save(opts)
      puts "Storing #{opts[:bucket]}/#{opts[:name]}..."
      AWS::S3::S3Object.store(opts[:name], opts[:blob], opts[:bucket], {
        :cache_control => 'max-age=315360000, public',
        :expires => (Time.now + 315360000).httpdate,
        :access => opts[:access]
      })
    end

  end
end
