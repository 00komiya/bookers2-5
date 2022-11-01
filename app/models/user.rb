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


  validates :name, length: { minimum: 2, maximum: 20 }, uniqueness: true
  validates :introduction, length: { maximum: 50}


  def get_profile_image
    (profile_image.attached?) ? profile_image : 'no_image.jpg'
  end

  # (user)←この引数に渡されたユーザーにフォローされているか否か
  def followed_by?(user)
    reverse_of_relationships.find_by(followed_id: user.id).present?
  end

 end