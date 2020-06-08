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

  def add_creature_to_initiative(creature)
    creatures << creature
    initiative_order << { 'creature_id' => creature.id, 'result' => creature.roll_initiative, 'active' => true }
    initiative_order.sort! { |a, b| b['result'] <=> a['result'] }
    self.save
  end

  def roll_initiative
    initiative_array = []
    creatures.each do |creature|
      initiative_array << { creature_id: creature.id, result: creature.roll_initiative, active: true }
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
      next_creature_id = next_active_creature_id(last_creature_index)
    else
      self.history = []
      next_creature_id = initiative_order.first['creature_id']
    end
    # I know I'm not storing much data in this JSON right now, but I think I'll
    # need to add more as I add more features to the tracker.
    self.history << { creature_id: next_creature_id }
    self.save
  end

  def toggle_creature(creature_id)
    turn_index = initiative_order.index { |turn| turn['creature_id'] == creature_id.to_i }
    return if turn_index.nil?

    initiative_order[turn_index]['active'] = !initiative_order[turn_index]['active']

    # Prevent the possibility of no creatures being active
    if initiative_order.detect { |turn| turn['active'] == true }.nil?
      initiative_order[turn_index]['active'] = !initiative_order[turn_index]['active']
      return false
    end

    self.save
  end

  private

  def next_active_creature_id(last_creature_index)
    unless initiative_order[last_creature_index + 1].nil?
      next_creature = initiative_order[last_creature_index + 1]
    else
      next_creature = initiative_order[0]
      last_creature_index = -1
    end

    return next_creature['creature_id'] if next_creature['active']

    next_active_creature_id(last_creature_index + 1)
  end
end
