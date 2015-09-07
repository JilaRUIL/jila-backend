module ActiveAdmin::AudioHelper
  def audio_link(model)
    if model.audio?
      link_to 'Listen', model.audio.url, target: 'window'
    else
      'No audio set'
    end
  end

  def call_audio_link(model)
    if model.call_audio?
      link_to 'Listen', model.call_audio.url, target: 'window'
    else
      'No audio set'
    end
  end

  def sentence_audio_link(model)
    if model.sentence_audio?
      link_to 'Listen', model.sentence_audio.url, target: 'window'
    else
      'No audio set'
    end
  end
end