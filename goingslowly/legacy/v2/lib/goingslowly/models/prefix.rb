module GS
  class Prefix < Sequel::Model
    one_to_many :journal
    many_to_one :section
  end
end
