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

  belongs_to :user
  has_and_belongs_to_many :encounters

  validates :name, :armor_class, :variety, presence: true
end
