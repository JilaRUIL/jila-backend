class AddFieldsToEntries < ActiveRecord::Migration
  def change
    add_column :entries, :sentence, :string
    add_column :entries, :sentence_translation, :string
    add_column :entries, :scientific_name, :string
    add_column :entries, :admin_only_notes, :text
  end
end
