require 'net/http'

# example 1
# url = "http://localhost/xxx"
# params = {id: 1}
# http = HttpCpt.get(url, args)

# example 2
# http = HttpCpt.new()
# http.url = "https://www.baidu.com"
# http.params = {id: 1}
# http.get

# result Obj use
# http.code for HTTP code
# http.code for HTTP response
# http.json for http json body

class HttpCpt

  attr_accessor :url
  attr_accessor :uri
  attr_accessor :action_method
  attr_accessor :params
  attr_accessor :code
  attr_accessor :body

  attr_accessor :start_time
  attr_accessor :end_time

  def initialize(_url=nil, _method=nil, _params=nil)
    @url = _url
    @action_method = _method
    @params = _params
  end

  def self.get(url, params = nil)
    http = HttpCpt.new(url, 'GET', params)
    http.get
  end

  def self.post(url, params = nil)
    http = HttpCpt.new(url, 'POST', params)
    http.post
  end

  def json
    body.load rescue nil
  end

  def get
    return failed unless start_init
    @uri.query = URI.encode_www_form(@params)
    begin
      res = Net::HTTP.get_response(@uri)
      result(res)
    rescue Exception => e
      Rails.logger.error e
      failed
    end
  end

  def post
    return failed unless start_init
    begin
      res = Net::HTTP.post_form(@uri, @params)
      result(res)
    rescue Exception => e
      Rails.logger.error e
      failed
    end
  end

  private

  def failed
    'HTTP - GET failed'
  end

  def start_init
    if url.nil?
      Rails.logger.error 'Error: HTTP url is not defined'
      return false
    else
      @uri = URI(url) rescue nil
    end

    @start_time = Time.now
    Rails.logger.info "[%s HTTP - %s] %s, @params: %s " %
    [Time.now, @action_method,  url, @params || 'nil']
    true
  end

  def result(res)
    @code = res.code
    @body = res.body
    @end_time = Time.now
    Rails.logger.info "[%s HTTP - %s] Completed %s in %s ms" %
    [Time.now, @action_method, @code, ((@end_time.to_f - @start_time.to_f) * 1000).to_i]
    self
  end
end
