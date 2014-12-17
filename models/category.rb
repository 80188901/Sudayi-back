class Category
  include Mongoid::Document
  include Mongoid::Timestamps # adds created_at and updated_at fields
  belongs_to :category
  # field <name>, :type => <type>, :default => <value>
  field :name, :type => String

  # You can define indexes on documents using the index macro:
  # index :field <, :unique => true>

  # You can create a composite key in mongoid to replace the default id using the key macro:
  # key :field <, :another_field, :one_more ....>

  def self.judgeLeaf(cate_id)
      category = where(:category_id => cate_id).first
      category ? category :nil
  end

  def self.findLeaves(cate_id,arr)
  	output_arr = arr
  	categories = where(:category_id => cate_id)
  	if categories
  	     categories.each_with_index do |cate, index|
  		category=judgeLeaf(cate._id)
  		if category
  			output_arr.push(category)
  			next
  		else
                                  findLeaves(cate_id,output_arr)
  		end
  	    end
  	end
               output_arr
  end
end
