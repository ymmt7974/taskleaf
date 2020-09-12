class Task < ApplicationRecord
  before_validation :set_nameless_name

  validates :name, presence: true
  validates :name, length: { maximum: 30 }
  validate :validate_name_not_including_comma

  private

  # [before]
  # 名称：空白の場合、「（名前なし）」を設定
  def set_nameless_name
    self.name = '（名前なし）' if name.blank?
  end

  # 名称：カンマチェック
  def validate_name_not_including_comma
    errors.add(:name, 'にカンマ(,)を含めることはできません') if name&.include?(',')
  end


end
