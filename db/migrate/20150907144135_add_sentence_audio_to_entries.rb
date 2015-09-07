class AddSentenceAudioToEntries < ActiveRecord::Migration
  def change
	change_table :entries do |t|
	  t.attachment :sentence_audio
	end
  end
end
