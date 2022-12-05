class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books, dependent: :destroy
  has_one_attached :profile_image
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy

  # フォローをする側からのhas_many、自分がフォローしている人の一覧を持ってくる
  has_many :relationships, foreign_key: :followed_id, dependent: :destroy
  has_many :follows, through: :relationships, source: :follower

　# フォローされた側からのhas_many、自分をフォローしている人の一覧を持ってくる
  has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: :follower_id, dependent: :destroy
  has_many :followers, through: :reverse_of_relationships, source: :followed

  # DM機能
  has_many :entries
  has_many :messages
  has_many :rooms, through: :entries


  validates :name, length: { minimum: 2, maximum: 20 }, uniqueness: true
  validates :introduction, length: { maximum: 50}


  def get_profile_image
    (profile_image.attached?) ? profile_image : 'no_image.jpg'
  end

  # (user)←この引数に渡されたユーザーにフォローされているか否かのアクション
  def followed_by?(user)
    reverse_of_relationships.find_by(followed_id: user.id).present?
  end

  # 検索方法分岐
  def self.looks(search, word)
    if search == "perfect_match" # 完全一致
      @user = User.where("name LIKE?", "#{word}")
    elsif search == "forward_match"  # 前方一致のため後ろに%
      @user = User.where("name LIKE?","#{word}%")
    elsif search == "backward_match" # 後方一致のため前に%
      @user = User.where("name LIKE?","%#{word}")
    elsif search == "partial_match" # 部分一致のため前後に%
      @user = User.where("name LIKE?","%#{word}%")
    else
      @user = User.all
    end
  end
end