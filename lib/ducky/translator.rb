require "ducky/command"

module Ducky

  module Translator
    def self.phrases
      [
        "commands",
        "help",
        "inventory",
        "look",
        "quit",

        "buy [noun]",
        "climb down [noun]",
        "drop [noun]",
        "go [noun]",
        "look at [noun]",
        "look in [noun]",
        "smash [noun]",
        "take [noun]",
        "unlock [noun]",

        "climb down [noun] with [object]",
      ]
    end

    def self.abbreviations
      {
        "q" => "quit",
        "n" => "north",
        "s" => "south",
        "e" => "east",
        "w" => "west",
        "u" => "up",
        "d" => "down",
        "i" => "inventory",
        "x" => "look at",
      }
    end

    def self.synonyms
      {
        "break" => "smash",
        "destroy" => "smash",
        "examine" => "look at",
        "get" => "take",
        "open" => "unlock",
        "purchase" => "buy",
        "walk" => "go",
      }
    end

    # translate input into game-usable commands
    def translate( text )
      # remove non-word, non-whitespace, non-number characters
      text.gsub!( /[^[:word:]\s\d]/, "" )

      # make the text lowercase and split it on whitespace
      words = text.downcase.split( /\s+/ )

      words.collect! do |word|
        if Translator.abbreviations.keys.include?( word )
          Translator.abbreviations[ word ]
        elsif Translator.synonyms.keys.include?( word )
          Translator.synonyms[ word ]
        else
          word
        end
      end

      translation = words.join( " " )

      translation.gsub!( "pick up", "take" )
      translation.gsub!( "climb into", "climb down" )
      translation.gsub!( "put down", "drop" )
      translation = "go north" if translation == "north"
      translation = "go south" if translation == "south"
      translation = "go east" if translation == "east"
      translation = "go west" if translation == "west"
      translation = "go up" if translation == "up"
      translation = "go down" if translation == "down"

      if translation.start_with?( "go" )
        possible_directions = ["north", "south", "west", "east", "up", "down"]
        possible_commands = possible_directions.collect { |d| "go #{d}" }

        unless possible_commands.include?( translation )
          puts "You must enter a valid direction to go."
          translation = ""
        end
      end

      command = Command.new( nil, nil, nil )

      for phrase in Translator.phrases
        pattern = make_pattern( phrase )
        match_data = pattern.match( translation )

        unless match_data.nil?
          if match_data.names.include?( "object" )
            command = Command.new( match_data[:verb], match_data[:noun], match_data[:object] )
          elsif match_data.names.include?( "noun" )
            command = Command.new( match_data[:verb], match_data[:noun] )
          else
            command = Command.new( match_data[:verb] )
          end
        end
      end


      command
    end

    def make_pattern( phrase )
      blanks = phrase.scan( /\[(.*?)\]/ ).flatten
      non_blanks = phrase.split( /\s?\[.*?\]\s?/, -1 )

      case blanks.length
      when 0
        /\A(?<verb>#{non_blanks[ 0 ]})\Z/
      when 1
        /\A(?<verb>#{non_blanks[ 0 ]}) (?<#{blanks[ 0 ]}>.*)\Z/
      else
        pattern = "\\A(?<verb>#{non_blanks[ 0 ]}) (?<#{blanks[ 0 ]}>.*)"
        1.upto( blanks.length - 1 ) do |i|
          pattern += " #{non_blanks[ i ]} (?<#{blanks[ i ]}>.*)"
        end
        if non_blanks.length > blanks.length && non_blanks.last != "" && non_blanks.last != ""
          pattern += " #{non_blanks[ non_blanks.length - 1 ]}"
        end
        pattern += "\\Z"
        Regexp.new( pattern )
      end
    end
  end

end
