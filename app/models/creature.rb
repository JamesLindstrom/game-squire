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

class Creature < ApplicationRecord
  enum variety: { player: 0, npc: 1, event: 2 }
  default_scope { order(:variety, :name) }

  belongs_to :user
  has_and_belongs_to_many :encounters

  validates :name, :variety, presence: true
  validate :require_proper_initiative_field

  def roll_initiative
    if variety == 'event'
      initiative_value
    else
      die_roll = rand(1..20)
      # If a creature has advantage on their initiative rolls, they get to
      # roll twice and pick the best roll.
      die_roll = [die_roll, rand(1..20)].max if advantage
      die_roll + initiative_bonus
    end
  end

  private

  def require_proper_initiative_field
    if variety == 'event'
      errors.add(:initiative_value, 'cannot be blank') if initiative_value.nil?
    else
      errors.add(:initiative_bonus, 'cannot be blank') if initiative_bonus.nil?
    end
  end
end
