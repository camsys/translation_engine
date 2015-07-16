class TranslationKey < ActiveRecord::Base

  validates :name, length: { maximum: 255 }

end