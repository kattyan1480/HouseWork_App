class Category < ApplicationRecord
  belongs_to :group
  has_many :chores, dependent: :destroy

  has_one_attached :stamp

  validates :name, presence: true
  validates :color, presence: true
  validate :stamp_must_be_attached

  def stamp_must_be_attached
    errors.add(:stamp, "を選択してください") unless stamp.attached?
  end

  PASTEL_COLORS = {
    "さくら"     => "#FFD1DC",
    "そら"       => "#CDE7FF",
    "みどり"     => "#D4F4DD",
    "きいろ"     => "#FFF4B8",
    "むらさき"   => "#E5D4FF",
    "みずいろ"   => "#CFFAFE",
    "オレンジ"   => "#FFE5CC",
    "グレー"     => "#E5E7EB"
  }.freeze

  DEFAULT_CATEGORIES = [
    { name: "料理", color: "#FFD1DC", stamp: "cooking.png" },
    { name: "洗濯",   color: "#CDE7FF", stamp: "washing.png" },
    { name: "掃除",     color: "#D4F4DD", stamp: "cleaning.png" },
    { name: "買い物",     color: "#FFF4B8", stamp: "shopping.png" }
  ]

def self.create_defaults_for(group)
  DEFAULT_CATEGORIES.each do |cat|
    file_name = cat[:stamp]
    file_name += ".png" unless file_name.end_with?(".png")

    file_path = Rails.root.join("app/assets/images", file_name)
    raise "画像ファイルが存在しません: #{file_path}" unless File.exist?(file_path)

    category = Category.new(
      group: group,
      name: cat[:name],
      color: cat[:color]
    )

    file_data = File.binread(file_path)

    category.stamp.attach(
      io: StringIO.new(file_data),
      filename: "#{SecureRandom.hex}_#{file_name}",
      content_type: "image/png"
    )

    category.save!
  end
end

end