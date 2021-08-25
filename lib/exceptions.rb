module Exceptions
  class NotImplementedError < StandardError
    def initialize(msg = I18n.t("errors.messages.not_implenented"))
      super
    end
  end
end
