##
# Not tied to a database table, just using Sequel for easy validation.
#
module GS
  class Email < Sequel::Model
    plugin :validation_helpers
    include Helpers

    attr_reader :request
    attr_accessor :name, :email, :message

    def initialize(opts={})
      @request = opts
      super opts.params['contact']
      opts
    end

    def validate
      super
      validates_presence [:name, :email, :message], :allow_blank => false
      errors.add(:email,'invalid email') if !validEmail?(email)

      #if !recaptchaCorrect?(request.params)
      #  errors.add(:recaptcha,'letters did not match')
      #end
    end

  end
end
