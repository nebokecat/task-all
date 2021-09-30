class Task < ApplicationRecord
  enum status: { '未着手': 0, '着手中': 1, '完了': 2 }

  scope :with_title, ->(title) do
    where("name LIKE ?", "%#{title}%")
  end

  scope :with_status, ->(status) { where(status: status) }

  def self.search(title, status)
    if title == nil && status == nil
      # 検索なし
      all
    elsif title == nil
      # statusのみでの検索
      with_status(status)
    elsif status == nil
      # titleのみの検索
      with_title(title)
    else
      # statusとtitle検索
      with_status(status).with_title(title)
    end
  end


  # 作成日順のスコープ
  # scope :sort, -> (sort_colunm) { where(created_at: created_at).order(created_at: :desc) }
end
