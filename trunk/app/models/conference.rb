class Conference < ActiveRecord::Base
  has_many :talks
  has_many :tags
  has_many :speakers
  has_many :attendances
  has_many :attendees, :through => :attendances, :source => :user
end