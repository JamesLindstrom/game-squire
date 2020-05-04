# == Schema Information
#
# Table name: encounters
#
#  id            :integer          not null, primary key
#  name          :string           not null
#  history       :json
#  game_space_id :integer
#

class Encounter < ApplicationRecord
  belongs_to :game_space
  has_and_belongs_to_many :creatures

  validates :name, presence: true

  def user
    game_space.user
  end
end
