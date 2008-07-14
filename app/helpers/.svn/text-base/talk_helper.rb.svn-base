require 'fastercsv'

module TalkHelper
  def link_to_reviews_sort(name, attribute)
    new_order = 'desc'
    
    if attribute == @sort_by
      new_order = 'asc' if @order == 'desc'
    end
      
    return link_to(name, {:controller => 'talk', :action => 'reviews', :sort_by => attribute, :order => new_order})
  end
  
  def talk_reviews_to_csv(talks)
    FasterCSV.generate do |csv|
      csv << %w{ talk talk_rating num_votes num_attendees speakers }
      talks.each do |talk|
        talk_data = [talk.summary, number_with_precision(talk.rating, 2), talk.ratings.size, talk.interested.size]
        speakers = talk.speakers.map{ |s| s.name }.join(",")
        talk_data << speakers
        csv << talk_data
      end
    end
  end
  
  def speaker_ratings_to_csv(talks)
    speaker_talks = talks.map{ |t| t.speaker_talks }
    speaker_talks.flatten!

    FasterCSV.generate do |csv|
      csv << %w{ speaker_name speaker_rating num_ratings talk_name }
      speaker_talks.sort{ |a, b| a.name <=> b.name }.each do |speaker|
        csv << [speaker.name, number_with_precision(speaker.rating, 2), speaker.ratings.size, speaker.talk.summary]
      end
    end
  end
  
end