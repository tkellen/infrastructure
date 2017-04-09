module GS
  module Helpers
    ##
    # Build the context object required to populate the site footer.
    #
    # @return [Hash]
    #   Data for the footer template.
    #
    def footerContext
      { :journals => Journal.published.
                             select(:title, :href, :stamp, :date_publish).
                             limit(24).
                             order(:stamp.desc).
                             all,
        :topic_sections => Section.topics.all,
        :archive => Journal.published.countByMonth.all,
        :countries => Topic.countries.all
      }
    end
  end
end
