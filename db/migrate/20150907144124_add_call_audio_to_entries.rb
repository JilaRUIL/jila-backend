class AddCallAudioToEntries < ActiveRecord::Migration
  def change
	change_table :entries do |t|
	  t.attachment :call_audio
	end
  end
end
