require 'typhoeus'

class Scraper
  module Morrison
    class Browser
      URL = "http://morrison.com.br/"

      class << self
        def page
          response = Typhoeus::Request.get(URL + 'hotsite/default.asp',
                                           :headers => {:Cookie => asp_session_cookie},
                                           :follow_location => true)
          response.body
        end

        private

        def asp_session_cookie
          response = Typhoeus::Request.get(URL)
          all_cookies = response.headers_hash["Set-Cookie"]
        end
      end
    end
  end
end
