# == Schema Information
#
# Table name: game_spaces
#
#  id      :integer          not null, primary key
#  name    :string           not null
#  link    :string           not null
#  public  :boolean          default(FALSE), not null
#  user_id :integer
#

require "rails_helper"

RSpec.describe GameSpace, type: :model do
  it 'has a valid factory' do
    expect(create(:game_space)).to be_valid
  end

  describe 'associations' do
    it { should belong_to(:user) }
    it { should have_many(:encounters) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:link) }
  end

  it 'should generate a uuid link when initialized' do
    uuid_length = 36
    expect(build(:game_space).link.size).to eq uuid_length
  end
end
