require "jekyll-read-time"

WORD_PER_MINUTE = 180

def calculate_time( input )
  words = input.split.size;
  minutes = ( words / WORD_PER_MINUTE ).floor
  return minutes
end

module JekyllReadTime
  module ReadingTimeFilter
    def read_time( input )
      minutes = calculate_time(input)
      case minutes
      when 2 then minutes_s = 'two'
      when 3 then minutes_s = 'three'
      when 4 then minutes_s = 'four'
      when 5 then minutes_s = 'five'
      when 6 then minutes_s = 'six'
      when 7 then minutes_s = 'seven'
      when 8 then minutes_s = 'eight'
      when 9 then minutes_s = 'nine'
      else        minutes_s = minutes
      end
      minutes > 0 ? "#{minutes_s} minute read" : "less than one minute read"
    end
    Liquid::Template.register_filter(JekyllReadTime::ReadingTimeFilter)
  end

  module ReadingTimeFilterShort
    def read_time_short( input )
      minutes = calculate_time(input)
      minutes > 0 ? "#{minutes} min read" : "1 min read"
    end
    Liquid::Template.register_filter(JekyllReadTime::ReadingTimeFilterShort)
  end
end
