class EntrySerializer < ActiveModel::Serializer
  attributes :id, :entry_word, :word_type, :translation, :scientific_name, :sentence, :sentence_translation, :alternate_translations, :alternate_spellings, :description, :audio, :call_audio, :sentence_audio, :images, :categories

  def audio
    object.audio.url if object.audio.exists?
  end

  def call_audio
    object.call_audio.url if object.call_audio.exists?
  end

  def sentence_audio
    object.sentence_audio.url if object.sentence_audio.exists?
  end

  def images
    {
      thumbnail: object.image? ? object.image(:thumbnail) : nil,
      normal: object.image? ? object.image(:normal) : nil
    }
  end

  def categories
    object.categories.map(&:id)
  end
end
