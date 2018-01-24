module DailyShare
  module Helpers
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
