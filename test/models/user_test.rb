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
#  browser_id :string
#
require "test_helper"

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
