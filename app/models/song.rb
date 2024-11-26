# == Schema Information
#
# Table name: songs
#
#  id              :integer          not null, primary key
#  download_error  :text
#  download_status :integer
#  downloaded      :boolean          default(FALSE)
#  duration        :float
#  file_problem    :boolean
#  name            :string
#  not_embeddable  :boolean
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

  enum download_status: { pending: 0, downloading: 1, completed: 2, failed: 3 }

  scope :playable, -> { where(file_problem: [false, nil], not_embeddable: [false, nil]) }

  def mark_file_problem!
    update!(file_problem: true)
  end

  def resolve_file_problem!
    update!(file_problem: false)
  end
end
