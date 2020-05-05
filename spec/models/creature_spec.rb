# == Schema Information
#
# Table name: creatures
#
#  id               :integer          not null, primary key
#  name             :string           not null
#  variety          :integer          not null
#  armor_class      :integer
#  initiative_bonus :integer
#  advantage        :boolean
#  initiative_value :integer
#  user_id          :integer
#

require "rails_helper"

RSpec.describe Creature, type: :model do
  it 'has a valid factory' do
    expect(create(:creature)).to be_valid
    expect(create(:creature, :player)).to be_valid
    expect(create(:creature, :npc)).to be_valid
    expect(create(:creature, :event)).to be_valid
  end

  describe 'associations' do
    it { should belong_to(:user) }
    it { should have_and_belong_to_many(:encounters) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:variety) }
  end
end
