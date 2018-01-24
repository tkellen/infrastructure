module GS
  class Track < Sequel::Model
    many_to_one :locationEnd, :class => :'GS::Location', :key => :end_location_id
    many_to_one :locationStart, :class => :'GS::Location', :key => :start_location_id
    one_to_many :track_point

    dataset_module do
      def endingAt(id)
        eager(:locationEnd => proc { |ds| ds.select(:id,:lat.cast(Float),:lng.cast(Float)) })
        where(:end_location_id=>id)
      end

      def startingAt(id)
        eager(:locationStart => proc { |ds| ds.select(:id,:lat.cast(Float),:lng.cast(Float)) })
        where(:start_location_id=>id)
      end
    end

    def points
      track_point_dataset.
      select(:lat.cast(Float),:lng.cast(Float)).
      order(:id)
    end

    def pointsForMap
      points.naked.all.to_json
    end
  end
end
