class TranslationKey < ApplicationRecord

  validates :name, length: { maximum: 255 }

end