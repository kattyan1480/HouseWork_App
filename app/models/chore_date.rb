class ChoreDate < ApplicationRecord
  belongs_to :chore
  validates :execute_at, presence: true
  has_many :chore_histories
  enum status: {
    pending: 0,
    done: 1
  }
  # 実行日（表示用）
  def execute_date
    execute_at&.to_date
  end

  # 実行時間（表示用）
  def execute_time
    execute_at&.strftime("%H:%M")
  end
  
  validate :unique_execute_date_per_chore, if: :pending?

  private

  def unique_execute_date_per_chore
    return if execute_at.blank?

    exists = ChoreDate
      .where(chore_id: chore_id, status: :pending)
      .where("DATE(execute_at) = ?", execute_at.to_date)
      .where.not(id: id)
      .exists?

    if exists
      errors.add(:base, "同じ日付に既に登録されています")
    end
  end
end
