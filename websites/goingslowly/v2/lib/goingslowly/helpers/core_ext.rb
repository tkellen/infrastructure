module Enumerable
 def group_by
    return to_enum :group_by unless block_given?
    assoc = {}

    each do |element|
      key = yield(element)

      if assoc.has_key?(key)
        assoc[key] << element
      else
        assoc[key] = [element]
      end
    end

    assoc
  end unless [].respond_to?(:group_by)

  def hash_on(field)
    hash = {}
    each do |element|
      key = element[field]||element[field.to_sym]
      hash[key] = element if !key.nil?
    end
    hash
  end
end
