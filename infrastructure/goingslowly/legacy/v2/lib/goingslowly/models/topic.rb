module GS
  class Topic < Sequel::Model
    many_to_one :section
    many_to_many :journals, :class => :'GS::Journal'

    dataset_module do
      def countries
        where(:is_country=>true).
        order(:name)
      end
      def topics
        where(:is_country=>false).
        order(:name)
      end
      def byName(topic)
        where(Sequel.function(:lower,:name)=>topic.gsub(/\+/,' ').downcase)
      end
    end

    def journals
      journals_dataset.
      publishedList.
      order(:stamp)
    end

    def isCountry?
      is_country == true
    end

    def href
      link_name = name.gsub(/ /,"+").downcase
      if is_country
        "/country/#{link_name}"
      else
        "/topic/#{link_name}"
      end
    end
  end
end
