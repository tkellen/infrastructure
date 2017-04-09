module GS
  class Author < Sequel::Model
    one_to_many :journal
  end
end
