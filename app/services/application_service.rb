class ApplicationService
  def self.call(*params)
    new(*params).call
  end
end
