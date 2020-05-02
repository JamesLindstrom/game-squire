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

class Player < Creature
  validates :initiative_bonus, presence: true
end
