module GS
  class Parser
    ##
    # Process a string for photo tokens, replacing the
    # tokens with formatted HTML.
    #
    # @option params [String] input
    #   The content to process.
    # @return [String]
    #   The content with HTML in place of tokens.
    #
    def self.process(input)
      # get tokens from input
      photoTokens = self.getPhotoTokens(input)
      # get ids from tokens
      photoIds = self.getTokenIds(photoTokens)
      # get photos using ids
      photos = self.getPhotos(photoIds)
      # build regexp to match all tokens
      photoRegexp = self.buildRegexp(photoTokens)

      # replace all photo tokens
      input.gsub!(photoRegexp) do |token|
        # extract settings from token
        id, type = self.processToken(token)
        # lookup photo by id
        photo = photos[id]
        # render photo in specific form
        Media.renderPhoto(type, photo)
      end

      # get media from input
      mediaTokens = self.getMediaTokens(input)
      # build regexp to match all tokens
      mediaRegexp = self.buildRegexp(mediaTokens)

      # replace all video tokens
      input.gsub!(mediaRegexp) do |token|
        # extract settings from token
        id, type, start = self.processToken(token)
        # render video in specific form
        Media.renderElement(type, {:id=>id,:start=>start})
      end

      input
    end

    ##
    # Extract media tokens in the form of [{mediaid,service}].
    #
    # @option params [String] input
    #   The content to search.
    # @return [Array]
    #   An array of tokens.
    #
    def self.getMediaTokens(input)
      input.scan(/\[\{[^\|\]]*\}\]/).flatten
    end

    ##
    # Extract photo tokens in the form of [|photoid,service|].
    #
    # @option params [String] input
    #   The content to search.
    # @return [Array]
    #   An array of tokens.
    #
    def self.getPhotoTokens(input)
      input.scan(/\[\|[^\|\]]*\|\]/).flatten
    end

    ##
    # Extract IDs from an array of token strings.
    #
    # @option params [Array] tokens
    #   An array of token strings.
    # @return [Array]
    #   An array of tokens IDs.
    #
    def self.getTokenIds(tokens)
      tokens.map { |token| self.processToken(token)[0] }
    end

    ##
    # Retrieve all photos and hash on ID for lookup.
    #
    # @option params [Array] photos
    #   An array of photo IDs.
    # @return [Hash]
    #   A hash of photo data keyed by photo ID.
    #
    def self.getPhotos(photos)
      Photo.byFlickrId(photos).all.hash_on(:f_id)
    end

    ##
    # Convert a token into logical parts
    #
    # @option params [String] token
    #   The token to process.
    # @return [Array]
    #   An array of values from the token.
    #
    def self.processToken(token)
      token = token[2...-2].split(',')
      token[1] = 'standard' if token.length == 1
      token
    end

    ##
    # Build a regular expression that will match all tokens.
    #
    # @option params [Array] tokens
    #   An array of token strings.
    # @return [Regexp]
    #   A regular expression matching all tokens.
    #
    def self.buildRegexp(tokens)
      Regexp::union(tokens)
    end

  end
end
