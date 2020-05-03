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

RSpec.describe Creature, type: :model do
  it 'has a valid factory' do
    expect(create(:creature)).to be_valid
  end
end
