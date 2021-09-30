class Task < ApplicationRecord
  validates :name, presence: true
  validates :description, presence: true
  enum status: { '未着手': 0, '着手中': 1, '完了': 2 }

  # 　動作確認観点：curl 叩いて部分一致できているか
  scope :with_title, lambda { |title|
    where('name LIKE ?', "%#{title}%")
  }

  scope :with_status, ->(status) { where(status: status) }

  # 　動作確認観点：curl 叩いて以下4パターンのロジックが動作しているか
  def self.search(title, status)
    if title.nil? && status.nil?
      # 検索なし
      all
    elsif title.nil?
      # statusのみでの検索
      with_status(status)
    elsif status.nil?
      # titleのみの検索
      with_title(title)
    else
      # statusとtitle検索
      with_status(status).with_title(title)
    end
  end
end
