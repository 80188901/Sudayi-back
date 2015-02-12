class Product
  include Mongoid::Document
  include Mongoid::Timestamps # adds created_at and updated_at fields
  belongs_to :website
  belongs_to :payment
  belongs_to :store
  belongs_to :state
  belongs_to :category
  belongs_to :account
  # field <name>, :type => <type>, :default => <value>
  field :name, :type => String
  field :description, :type => String
  field :price, :type => Float
  field :storage, :type => Integer
  field :level,  :type => Integer

  def self.qcode(id)
    #二维码
    product = find(id)
    url = 'http://'+request.host+'get_product?pid='+id
    qr=RQRCode::QRCode.new(url)
    png=qr.to_img  # returns an instance of ChunkyPNG
    png.resize(300, 300).save('/home/simon/fancyshop_0.3/public/images/erweima/'+id+'.png')
  end
  # You can define indexes on documents using the index macro:
  # index :field <, :unique => true>

  # You can create a composite key in mongoid to replace the default id using the key macro:
  # key :field <, :another_field, :one_more ....>
end
