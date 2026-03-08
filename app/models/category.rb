class Category < ApplicationRecord
  belongs_to :group
  has_many :chores, dependent: :destroy

  has_one_attached :stamp

  validates :name, presence: true
  validates :stamp, presence: true
  validates :color, presence: true

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
    { name: "料理", color: "#FFD1DC", stamp: "料理.png" },
    { name: "洗濯",   color: "#CDE7FF", stamp: "洗濯.png" },
    { name: "掃除",     color: "#D4F4DD", stamp: "掃除.png" },
    { name: "買い物",     color: "#FFF4B8", stamp: "買い物.png" }
  ]

  def self.create_defaults_for(group)
    DEFAULT_CATEGORIES.each do |cat|
      category = Category.new(
        group: group,
        name: cat[:name],
        color: cat[:color]
      )

      category.stamp.attach(
        io: File.open(Rails.root.join("app/assets/images/default_categories/#{cat[:stamp]}")),
        filename: cat[:stamp]
      )

      category.save!
    end
  end

end