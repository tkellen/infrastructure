module DailyShare
  class Member < Sequel::Model
    one_to_many :photos

    def self.byName(name)
      self[:name=>name]
    end

    def self.byEmail(email)
      self[:email=>email.downcase]
    end

    def missingPhotos
      DB["SELECT
            date('2012-01-01'::date+(interval '1 day'*s.num)) AS date
          FROM
            (SELECT generate_series(0,now()::date-'2012-01-01'::date) AS num) AS s
          WHERE
            (SELECT
               true
             FROM
               photos
             WHERE
               date_added=date('2012-01-01'::date+(interval '1 day'*s.num))
             AND
               member_id=?) IS null",id]
    end

    def mostRecentPhoto
      photos_dataset.order(:date_added.desc).first
    end

    def submissionByDate(date)
      photos_dataset.where(:date_added=>date).first
    end

  end
end
