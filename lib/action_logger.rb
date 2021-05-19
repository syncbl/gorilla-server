module ActionLogger
  def self.log(message = "")
    @action_logger ||= Logger.new("#{Rails.root}/log/actions.log")
    @action_logger.info "#{self.class.name}, #{caller[0][/`.*'/][1..-2]} #{id} #{message}".strip
  end
end  
