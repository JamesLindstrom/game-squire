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
  default_scope { order(:variety) }

  belongs_to :user
  has_and_belongs_to_many :encounters

  validates :name, :variety, presence: true
  validate :require_proper_initiative_field

  private

  def require_proper_initiative_field
    if variety == 'event'
      errors.add(:initiative_value, 'cannot be blank') if initiative_value.nil?
    else
      errors.add(:initiative_bonus, 'cannot be blank') if initiative_bonus.nil?
    end
  end
end
