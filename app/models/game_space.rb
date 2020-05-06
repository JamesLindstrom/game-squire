# == Schema Information
#
# Table name: game_spaces
#
#  id                   :integer          not null, primary key
#  name                 :string           not null
#  link                 :string           not null
#  public               :boolean          default(FALSE), not null
#  user_id              :integer
#  current_encounter_id :integer
#

class GameSpace < ApplicationRecord
  belongs_to :user
  belongs_to :current_encounter, class_name: 'Encounter', optional: true
  has_many :encounters, dependent: :destroy
  has_and_belongs_to_many :players, class_name: 'Creature'

  validates :name, :link, presence: true

  def initialize(params)
    params ||= {}
    params[:link] ||= SecureRandom.uuid
    super(params)
  end
end
