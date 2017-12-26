module GS
  class TrackPoint < Sequel::Model
    many_to_one :track
  end
end
