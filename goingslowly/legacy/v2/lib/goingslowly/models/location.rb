module GS
  class Location < Sequel::Model
    many_to_many :journal
    one_to_one :trackIn, :class => :'GS::Track', :key => :end_location_id
    one_to_one :trackOut, :class => :'GS::Track', :key => :start_location_id

    dataset_module do
      def listing
        select(:id,:lat,:lng,:marker).order(:id)
      end

      def journalsForMapAt(id)
        eager(:journal=>{proc{|ds| ds.select(:journal__id,:journal__title,:journal__photo_id,:journal__url).published} => :photo}).
        where(:location__id=>id)
      end
    end

    def forMap
      {
        :id => id,
        :lat => lat.to_f.round(4),
        :lng => lng.to_f.round(4),
        :marker => marker,
        :infowindow => true
      }
    end

    def journals
      journal_dataset.published
    end
  end
end
