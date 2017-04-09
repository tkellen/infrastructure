##
# Not tied to a database table, just using Sequel for easy validation.
#
module GS
  class Newsletter < Sequel::Model
    plugin :validation_helpers
    include Helpers

    attr_reader :request
    attr_accessor :name, :email

    def initialize(opts={})
      @request = opts
      super opts.params['newsletter']
      opts
    end

    def validate
      super
      validates_presence [:name, :email], :allow_blank => false
      errors.add(:email,'invalid email') if !validEmail?(email)
    end

  end
end
