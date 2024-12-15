# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  avatar     :integer
#  email      :string
#  name       :string
#  nickname   :string
#  picture    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  auth0_id   :string
#  browser_id :string
#
class User < ApplicationRecord
  has_many :user_songs
  has_many :songs, through: :user_songs

  AVATAR_COUNT = 12

  def avatar_url
    return nil if avatar.nil?
    "/images/avatars/avatar_#{avatar}.png"
  end

  def self.available_avatars
    (1..AVATAR_COUNT).to_a
  end
end
