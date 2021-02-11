module HashFileList
  class << self
    def flatten(hash = {})
      hash.each_with_object({}) do |(k, v), h|
        if v.is_a? Hash
          flatten_hash(v).map do |h_k, h_v|
            h["#{k}/#{h_k}"] = h_v
          end
        else
          h[k] = v
        end
      end
    end

    def extend(hash, item, value)
      k = hash
      h = item.split("/")
      key = h.pop
      h.each { |v| k = k[v] ||= {} }
      k[key] = value
      hash
    end
  end
end
