#encoding: utf-8
class Des
  require 'openssl'
  require 'base64'
 
  ALG = 'DES-EDE3-CBC'
  KEY = 'P56tx8aE'
  DES_KEY = 'joHvJZX3'
 
  class << self
    def encode(str)
      return if str.blank?
      des = OpenSSL::Cipher.new ALG
      des.pkcs5_keyivgen KEY, DES_KEY
      des.encrypt
      cipher = des.update str
      cipher << des.final
      Base64.urlsafe_encode64 cipher
    end
 
    def decode(str)
      return if str.blank?
      str = Base64.urlsafe_decode64 str
      des = OpenSSL::Cipher.new ALG
      des.pkcs5_keyivgen KEY, DES_KEY
      des.decrypt
      des.update(str) + des.final
    end

    def decode_arr (array)
      return if array.blank?
      members = []
      array.map do |mem|
        members << Des.decode(mem)
      end
      members.to_json
    end
  end
end