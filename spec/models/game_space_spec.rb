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
end