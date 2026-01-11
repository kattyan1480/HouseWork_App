class ChoreDate < ApplicationRecord
  belongs_to :chore
  validates :execute_at, presence: true
  enum status: { pending: 0, done: 1 }

  # 実行日（表示用）
  def execute_date
    execute_at&.to_date
  end

  # 実行時間（表示用）
  def execute_time
    execute_at&.strftime("%H:%M")
  end
end
