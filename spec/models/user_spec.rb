# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  name                   :string           default(""), not null
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

require "rails_helper"

RSpec.describe User, type: :model do
  it 'has a valid factory' do
    expect(create(:user)).to be_valid
  end

  describe 'associations' do
    it { should have_many(:creatures) }
    it { should have_many(:game_spaces) }
  end

  describe 'validations' do
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:password) }

    it 'should validate uniqueness of email' do
      user1 = create(:user)
      user2 = build(:user, email: user1.email)
      expect(user2).to_not be_valid

      user2.email = Faker::Internet.unique.email
      expect(user2).to be_valid
    end
  end
end
