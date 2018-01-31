class Translation < ApplicationRecord

  belongs_to :locale
  belongs_to :translation_key

  delegate :name, to: :translation_key, prefix: :key, allow_nil: true

  attr_reader :key

  def key
    @key || key_name
  end

end