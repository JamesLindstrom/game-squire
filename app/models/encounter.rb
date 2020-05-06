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
    self.update(initiative_order: initiative_array, history: [])
  end

  def next_turn
    return false unless initiative_order&.any?

    if self.history&.any?
      # Get the index of the last creature to have a turn
      last_creature_id = self.history.last['creature_id']
      last_creature_index = initiative_order.index do |order_entry|
        order_entry['creature_id'] == last_creature_id
      end

      # Use the index to find out who should be next
      unless initiative_order[last_creature_index + 1].nil?
        next_creature_id = initiative_order[last_creature_index + 1]['creature_id']
      else
        next_creature_id = initiative_order[0]['creature_id']
      end
    else
      self.history = []
      next_creature_id = initiative_order.first['creature_id']
    end
    # I know I'm not storing much data in this JSON right now, but I think I'll
    # need to add more as I add more features to the tracker.
    self.history << { creature_id: next_creature_id }
    self.save
  end
end
