class Book < ApplicationRecord
  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :favorited_users, through: :favorites, source: :user
  has_many :book_comments, dependent: :destroy

  validates :title,presence:true
  validates :body,presence:true,length:{maximum:200}

  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end

  # 検索方法分岐
  def self.looks(search, word)
    if search == "perfect_match" # 完全一致
      @book = Book.where("title LIKE?","#{word}")
    elsif search == "forward_match" # 前方一致のため後ろに%
      @book = Book.where("title LIKE?","#{word}%")
    elsif search == "backward_match" # 後方一致のため前に%
      @book = Book.where("title LIKE?","%#{word}")
    elsif search == "partial_match" # 部分一致のため前後に%
      @book = Book.where("title LIKE?","%#{word}%")
    else
      @book = Book.all
    end
  end

end
