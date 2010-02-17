module Pork
  class Auth
    attr_accessor :auth
    attr_reader :username, :password
    def initialize(username, password, user_agent = '')
      @auth = Twitter::Base.new(Twitter::HTTPAuth.new(username, password, :user_agent => user_agent))
    end

  end
end

