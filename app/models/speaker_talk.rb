class SpeakerTalk < ActiveRecord::Base
  belongs_to :talk
  belongs_to :user
  acts_as_rateable

  def name 
    user ? user.name : @attributes["name"]
  end
end
