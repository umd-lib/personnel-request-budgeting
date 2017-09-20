class AddOwner < ActiveRecord::Migration
  def change
    add_reference :requests, :user, index: true
    add_reference :archived_requests, :user, index: true 
	end
end
