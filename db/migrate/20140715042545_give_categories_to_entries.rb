class GiveCategoriesToEntries < ActiveRecord::Migration
  def change
  	create_table :categories_entries, id: false do |t|
  		t.belongs_to :category
  		t.belongs_to :entry
  	end
  end
end
