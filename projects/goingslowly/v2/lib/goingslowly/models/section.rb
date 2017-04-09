module GS
  class Section < Sequel::Model
    one_to_many :topic

    dataset_module do
      def topics
        eager_graph(:topic => proc { |ds| ds.where(:is_country=>false)}).
        order([:ordering,:topic__name])
      end
    end
  end
end
