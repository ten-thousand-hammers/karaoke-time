# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  email      :string
#  name       :string
#  nickname   :string
#  picture    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  auth0_id   :string
#
class User < ApplicationRecord
  has_many :user_songs
  has_many :songs, through: :user_songs
end
