class ActiveRecord::Base
  @@conference = nil
  
  def self.conference
    @@conference
  end
  
  def self.conference=(conf)
    @@conference = conf
  end  
end
