module GS
  class Rating < Sequel::Model
    one_to_many :journals, :class => :'GS::Journal'

    dataset_module do
      def byName(topic)
        where(Sequel.function(:lower,:name)=>topic.gsub(/\+/,' ').downcase)
      end
    end

    def display
      @values[:display]
    end

    def journals
      journals_dataset.publishedList.order(:stamp)
    end
  end
end
