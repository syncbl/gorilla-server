module HashFileList
  class << self
    def flatten(hash)
      hash.each_with_object({}) do |(k, v), h|
        if v.is_a? Hash
          flatten(v).map do |h_k, h_v|
            h["#{k}/#{h_k}"] = h_v
          end
        else
          h[k] = v
        end
      end
    end

    def add(hash, path, value)
      k = hash
      h = path.split("/")
      key = h.pop
      h.each { |v| k = k[v] ||= {} }
      k[key] = value
      hash
    end

    def extend(hash)
      new_hash = {}
      hash.each { |k, v| self.add(new_hash, k, v) }
      new_hash
    end
  end
end
