# == Schema Information
#
# Table name: songs
#
#  id              :integer          not null, primary key
#  download_error  :text
#  download_status :integer
#  downloaded      :boolean          default(FALSE)
#  duration        :float
#  name            :string
#  path            :string
#  plays           :integer          default(0), not null
#  thumbnails      :json
#  url             :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  external_id     :string
#
class Song < ApplicationRecord
  has_many :user_songs
  has_many :users, through: :user_songs
end
