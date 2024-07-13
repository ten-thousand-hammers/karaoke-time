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
require "test_helper"

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
