module OmniAuth
  module Strategies
    class Facebook
      def request_phase
        if next_path = session['omniauth.params'].try(:[],"next")
          session[:next] = next_path
        end
        super
      end
    end
  end
end

module OmniAuth
  module Strategies
    class Twitter
      def request_phase
        if next_path = session['omniauth.params'].try(:[],"next")
          session[:next] = next_path
        end
        super
      end
    end
  end
end