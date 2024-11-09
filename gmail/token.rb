require 'net/http'

args = {
  :grant_type => 'authorization_code',
  :code => '4/2AGJaxgsGSAy_jvXbPjIi59DCFL71bTLZCXBsvIW7aQfEBTnP4J1avY',
  :client_id => '148122999130-1mbvj9ij49rj37kj4co49efi4nfpq6ks.apps.googleusercontent.com',
  :client_secret => '-8HgbADbGl9WwDuFhrthJTiD',
  :redirect_uri => 'urn:ietf:wg:oauth:2.0:oob',
}

url = "https://accounts.google.com/o/oauth2/token"
uri = URI(url)

res = Net::HTTP.post_form(uri, args)
p code = res.code
p body = res.body
