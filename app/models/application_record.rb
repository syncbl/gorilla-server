class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  self.implicit_order_column = :created_at

  private

  def action_log(message = '')
    @@action_logger ||= Logger.new("#{Rails.root}/log/actions.log")
    @@action_logger.info "#{self.class.name}, #{caller[0][/`.*'/][1..-2]} #{id} #{message}"
                           .strip
  end
end
