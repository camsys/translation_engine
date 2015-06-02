class Translation < ActiveRecord::Base

  belongs_to :locale
  belongs_to :translation_key

  validates :locale_id, :uniqueness => {:scope => [:locale_id, :translation_key_id]}
  validates :translation_key_id, :uniqueness => {:scope => [:locale_id, :translation_key_id]}

end
