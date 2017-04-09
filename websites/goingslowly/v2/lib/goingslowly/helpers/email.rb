require 'mail'

module GS
  module Helpers

    ##
    # Validate an email address.
    #
    # @param [String] email
    #   The email to validate.
    #
    # @return [Boolean]
    #   True if email is valid, false if not.
    #
    def validEmail?(email)
      begin
       return false if email == ''
       parsed = Mail::Address.new(email)
       return parsed.address == email && parsed.local != parsed.address
      rescue Mail::Field::ParseError
        return false
      end
    end

    ##
    # Send an multi-part email using mail gem.
    #
    # @param [String] to
    #   Address to send email.
    # @param [String] subject
    #   Subject of email to send, prefixed by CONFIG['email']['subject_prefix']
    # @param [String] body_html
    #   HTML formatted body of email to send
    # @param [String] from
    #   Address to send email from.
    # @return [Boolean]
    #   True if mail was delivered, false if not.
    #
    def sendEmail(to, subject, body, from=CONFIG['email']['from'])
      MGun.messages.send_email({
        :to => to,
        :from => from,
        :subject => subject,
        :text => body.gsub(/<\/?[^>]*>/,""),
        :html => body
      })
    end

  end
end
