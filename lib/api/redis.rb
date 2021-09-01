class Api::Redis
  require 'redis'
  require 'connection_pool'

  def pool
    @redis_pool ||=
      ConnectionPool.new(
        size: ActiveRecord::Base.connection_pool.db_config.pool,
      ) do
        Redis.new(url: ENV.fetch('REDIS_URL') { 'redis://localhost:6379/1' })
      end
  end
end
