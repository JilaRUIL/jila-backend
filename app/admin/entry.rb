ActiveAdmin.register Entry do

  csv_importable :columns => [:entry_word, :word_type, :translation, :scientific_name, :sentence, :sentence_translation],
                              :import_unique_key => :code

  controller do
    cache_sweeper :api_sweeper

    def create
      create! do |format|
        format.html { redirect_to edit_admin_entry_path(Entry.last) }
      end
    end

    def update
      update! do |format|
        format.html { redirect_to edit_admin_entry_path }
      end
    end
  end

  actions :all, except: [:show]

  permit_params :entry_word, :word_type, :translation, :scientific_name, :sentence, :sentence_translation, :alternate_translations_raw, :alternate_spellings_raw, :display_order, :description, :admin_only_notes,
                :published?, :image, :audio, :call_audio, :sentence_audio, image_credit_attributes: [:attribution_text, :link], category_ids: []

  form(html: { multipart: true }) do |f|
    f.inputs 'Details' do
      f.input :entry_word
      f.input :word_type, as: :select, collection: Entry::WORD_TYPES
      f.input :translation
      f.input :scientific_name
      f.input :alternate_translations_raw, as: :text, label: 'Alternate translations - One per line', placeholder: 'One per line', input_html: {rows: 3}
      f.input :alternate_spellings_raw, as: :text, label: 'Alternate spellings - One per line', placeholder: 'One per line', input_html: {rows: 3}
      f.input :description
      f.input :display_order, hint: 'optional - if not specified will be sorted alphabetically'
      f.input :published?
    end

    f.inputs 'Example Sentence' do
      f.input :sentence
      f.input :sentence_translation
    end 

    f.inputs 'Image' do
      f.input :image, as: :file, label: 'Image - Must be JPEG, PNG or GIF', hint: thumbnail_image(f.object)
      f.inputs 'Image Credit', for: [:image_credit, f.object.image_credit || ImageCredit.new] do |icf|
        icf.input :attribution_text
        icf.input :link
      end
    end

    f.inputs 'Audio' do
      f.input :audio, as: :file, label: 'Word Audio (MP3/M4A)', hint: audio_link(f.object)
      f.input :call_audio, as: :file, label: 'Call Audio (MP3/M4A)', hint: call_audio_link(f.object)
      f.input :sentence_audio, as: :file, label: 'Sentence Audio (MP3/M4A)', hint: sentence_audio_link(f.object)
    end

    f.inputs 'Select categories' do
      f.input :categories, as: :check_boxes, collection: Category.all.sort_by(&:name)
    end
    
    f.inputs 'Admin notes' do
      f.input :admin_only_notes, hint: 'optional - not intended to be shown on front end and not included in app sync'
    end

    f.actions
  end

  batch_action :publish do |selection|
    Entry.find(selection).each { |e| e.update_attribute(:published?, true) }
    redirect_to collection_path, :notice => "Entries published"
  end

  batch_action :un_publish do |selection|
    Entry.find(selection).each { |e| e.update_attribute(:published?, false) }
    redirect_to collection_path, :notice => "Entries un-published"
  end

  batch_action :add_category_to, form: ->{{category: Category.pluck(:name, :id)}} do |selection, inputs|
    # Entry.find(selection).each { |e| e.categories << Category.find(inputs[:category]) }
    Entry.find(selection).each { |e|  
      if not inputs[:category].to_i.in?(e.category_ids)
        e.categories << Category.find(inputs[:category])
      end
    }   
    redirect_to collection_path, :notice => "Entries added to category"
  end

  index do
    selectable_column
    column :entry_word do |entry|
      link_to entry.entry_word, edit_admin_entry_path(entry)
    end
    column :translation do |entry|
      truncate(entry.translation, omision: "...", length: 100)
    end
    column :scientific_name
    column :published?
    column 'Order', :display_order
    column :image do |entry|
      thumbnail_image entry
    end
    column :audio do |entry|
      audio_link entry
    end
    column :categories do |entry|
      entry.categories.map do |c|
        span c.name, class: 'category'
      end
    end
    actions
  end

  filter :categories
  filter :entry_word
  filter :scientific_name
  filter :translation
  filter :published?, as: :select, collection: [true, false]
end
