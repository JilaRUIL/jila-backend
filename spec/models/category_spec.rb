require 'rails_helper'

RSpec.describe Category, :type => :model do
  let!(:tomorrow) { Category.create name: 'tomorrow', updated_at: Date.tomorrow }
  let!(:yesterday) { Category.create name: 'yesterday', updated_at: Date.yesterday }
  let!(:published) { Entry.create entry_word: 'published', word_type: 'noun', translation: 'published', published?: true, categories: [yesterday]}
  let!(:unpublished) { Entry.create entry_word: 'unpublished', word_type: 'noun', translation: 'unpublished', published?: false, categories: [tomorrow]}

  describe :since do
    it 'should filter categories modified before provided date' do
      categories = Category.since Date.today.to_s

      expect(categories).to_not include(yesterday)
      expect(categories).to include(tomorrow)
    end
  end

  describe :with_published_entries do
    it 'should filter categories with no published entries' do
      categories = Category.with_published_entries

      expect(categories).to include(yesterday)
      expect(categories).to_not include(tomorrow)
    end
  end
end
