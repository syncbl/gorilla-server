# TODO:
# 1. Puma tcp-mode
# 2. Timeouts
# 3. Redis, because rake task classes is separate from main code

class Push::Server
  include Api::Token

  def initialize
    @@server ||= TCPServer.open(5000)
    # TODO: establish_ssl_connection!
    @@clients ||= Hash.new
    @@running = false
  end

  def run!
    return false if @@running
    @@running = true
    Api::Redis.new.pool.with do |redis|
      loop do
        Thread.fork(@@server.accept) do |client|
          process_messages(client)
          @@clients.delete_if { |_, c| c == client }
        end
      end
    end
  rescue Interrupt => e
    exit!
  rescue StandardError => e
    # TODO:
  ensure
    @@running = false
  end

  class << self
    def notify(uuid, message)
      if defined?(@@clients)
        if client = @@clients[uuid]
          client.puts message
        end
      end
    rescue StandardError => e # TODO: Find out real error name
      false
    end

    def online?(uuid)
      defined?(@@clients) && @@clients.include?(uuid)
    end
  end

  private

  # TODO: No loop, only first message is required, than we can drop thread
  def process_messages(client)
    loop do
      if payload = client.gets&.chomp
        break unless command_token(payload)
      else
        break
      end
    end
  end

  def command_token(payload)
    scope, uuid, token = decode_token(payload)
    if (scope == "Endpoint") && cached_endpoint(uuid, token)
      @@clients[uuid] = client
    else
      false
    end
  end

  def establish_ssl_connection!
    ssl_context = OpenSSL::SSL::SSLContext.new
    ssl_context.cert = OpenSSL::X509::Certificate.new(File.read("lib/push/cert.pem"))
    ssl_context.key = OpenSSL::PKey::RSA.new(File.read("lib/push/privkey.pem"))
    ssl_context.extra_chain_cert = [OpenSSL::X509::Certificate.new(File.read("lib/push/chain.pem"))]
    ssl_context.ssl_version = :TLSv1_2
    ssl_context.verify_mode = OpenSSL::SSL::VERIFY_NONE
    @socket = OpenSSL::SSL::SSLServer.new(@server, ssl_context)
    #@socket.sync_close = true
    #@socket.connect
  end
end
