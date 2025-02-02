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
require "test_helper"

class SongTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
