## This file contains the configurations for pgcrypto(Encryption library)

# Setting encryption key
PGCrypto.mode = :symmetric

# Loading encryption key and its password from config
PGCrypto.keys[:symmetric] = {
  :value => ENV['ENCRYPTION_KEY_VALUE'],
  :password => ENV['ENCRYPTION_KEY_PASSWORD']
}
