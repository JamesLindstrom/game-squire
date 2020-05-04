# == Schema Information
#
# Table name: creatures
#
#  id               :integer          not null, primary key
#  name             :string           not null
#  type             :string           not null
#  armor_class      :integer          not null
#  initiative_bonus :integer
#  advantage        :boolean
#  initiative_value :integer
#  user_id          :integer
#

require "rails_helper"

RSpec.describe Event, type: :model do
  it 'has a valid factory' do
    expect(create(:event)).to be_valid
  end

  describe 'associations' do
    it { should belong_to(:user) }
    it { should have_and_belong_to_many(:encounters) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:armor_class) }
    it { should validate_presence_of(:type) }
    it { should validate_presence_of(:initiative_value) }
  end
end
