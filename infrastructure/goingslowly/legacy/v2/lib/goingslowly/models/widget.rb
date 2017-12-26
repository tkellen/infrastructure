module GS
  class Widget < Sequel::Model
    many_to_many :journal
  end
end
