# == Schema Information
#
# Table name: encounters
#
#  id               :integer          not null, primary key
#  name             :string           not null
#  history          :json
#  game_space_id    :integer
#  initiative_order :json
#

class Encounter < ApplicationRecord
  belongs_to :game_space
  has_and_belongs_to_many :creatures

  validates :name, presence: true

  def user
    game_space.user
  end

  def roll_initiative
    initiative_array = []
    creatures.each do |creature|
      if creature.variety == 'event'
        initiative = creature.initiative_value
      else
        die_roll = rand(1..20)
        # If a creature has advantage on their initiative rolls, they get to
        # roll twice and pick the best roll.
        die_roll = [die_roll, rand(1..20)].max if creature.advantage
        initiative = die_roll + creature.initiative_bonus
      end

      initiative_array << { creature_id: creature.id, result: initiative }
    end
    initiative_array.sort! { |a, b| b[:result] <=> a[:result] }
    self.update(initiative_order: initiative_array)
  end
end
