  require 'carrierwave/mongoid'
class AvatarUploader < CarrierWave::Uploader::Base
  storage :file
end