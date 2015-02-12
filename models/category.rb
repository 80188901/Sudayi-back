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

  def self.judgeLeaf(cate)
      category = where(:category_id => cate).first
      category ? category :nil
  end

  def self.findLeaves(cate,arr,isfirst)
  	#广度优先算法检索分类
  	output_arr = arr
  	categories = where(:category_id => cate)
  	if categories
            if isfirst
  	     output_arr.push(find(cate)._id)
       end
  	     categories.each do |cate|
  	     	output_arr.push(cate._id)
  		category=judgeLeaf(cate._id)
  		if category
  		          findLeaves(cate._id,output_arr,false)
                                      next 
  		else
                                 next
  		end
  	    end
  	else
  	end
  end
end
