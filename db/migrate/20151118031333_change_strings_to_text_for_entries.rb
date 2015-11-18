class ChangeStringsToTextForEntries < ActiveRecord::Migration
  def change
		change_column :entries, :translation, :text, :limit => nil
		change_column :entries, :sentence, :text, :limit => nil
		change_column :entries, :sentence_translation, :text, :limit => nil
  end
end
