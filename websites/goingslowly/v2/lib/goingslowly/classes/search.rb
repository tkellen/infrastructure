require 'cgi'

module GS
  class Search
    ##
    # Parse a query to:
    #   - urlencode
    #   - remove non alphanumeric characters
    #   - remove double / leading and trailing spaces
    #   - force lowercase
    #
    # @param [String] query
    #   String to be parsed.
    # @return [String]
    #   Parsed string.
    #
    def self.sanitize(query)
      CGI::escape((query||'').gsub(/[^0-9a-z +]/i,'').squeeze(' ').strip.downcase)
    end

    ##
    # Search database using Sphinx.
    #
    # @param [String] query
    #   Search query string.
    #
    # @return [Array]
    #   Matching journal IDs
    #
    def self.query(query)

      # parse search into advanced format
      query = query.split(/ and /).join(' & ').
                    split(/ or /).join(' | ')

      # query sphinx for matching toons
      search = SPHINX.query(query)

      # return all matches as an array
      search[:matches].map { |doc| doc[:doc] }
    end

  end
end
