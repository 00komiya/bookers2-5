class Favorite < ApplicationRecord

  belongs_to :user
  belongs_to :book

  # ひとりのユーザー(user_id)がひとつのbook_idに対して1いいね
  validates_uniqueness_of :book_id, scope: :user_id

end
