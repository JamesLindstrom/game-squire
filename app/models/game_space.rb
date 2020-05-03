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

class GameSpace < ApplicationRecord
  belongs_to :user
  has_many :encounters

  validates :name, :link, presence: true

  def initialize(params)
    params ||= {}
    params[:link] ||= SecureRandom.uuid
    super(params)
  end
end
