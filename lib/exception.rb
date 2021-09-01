module Exception
  class NotImplementedError < StandardError
    def initialize(msg = "This feature is not implemented")
      super
    end
  end
end
