class ApplicationJob < ActiveJob::Base
  # Automatically retry jobs that encountered a deadlock
  # retry_on ActiveRecord::Deadlocked
  # Most jobs are safe to ignore if the underlying records are no longer available
  # discard_on ActiveJob::DeserializationError
  queue_as :default

  require "timeout"

  def perform(...)
    Timeout.timeout(JOB_TIMEOUT) { safe_perform(...) }
  rescue Timeout::Error
    # TODO: Notify & source.block! "+++ TIMEOUT +++"
  end

  def safe_perform(...)
    # Abstract
  end
end
