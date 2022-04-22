class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  self.implicit_order_column = :created_at

  before_validation :nullify_empty_params, on: :save

  strip_attributes

  private

  def action_log(message = "")
    @action_logger ||= Logger.new(Rails.root.join("log/actions.log"))
    @action_logger.info "#{self.class.name}, #{caller(1..1).first[/`.*'/][1..-2]} #{id} #{message}"
      .strip
  end

  def nullify_empty_params
    params.each { |k, v| params[k] = nil if v.empty? }
  end
end
