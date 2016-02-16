require "ducky/command"

module Ducky

  module Translator
    # translate input into game-usable commands
    def translate( text )
      abbreviations = {
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

      synonyms = {
        "break" => "smash",
        "destroy" => "smash",
        "examine" => "look at",
        "get" => "take",
        "open" => "unlock",
        "purchase" => "buy",
        "walk" => "go",
      }

      # remove non-word, non-whitespace, non-number characters
      text.gsub!( /[^[:word:]\s\d]/, "" )

      # make the text lowercase and split it on whitespace
      words = text.downcase.split( /\s+/ )

      words.collect! do |word|
        if abbreviations.keys.include?( word )
          abbreviations[ word ]
        elsif synonyms.keys.include?( word )
          synonyms[ word ]
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

      verb_patterns = [
        /\A(?<verb>commands)\Z/,
        /\A(?<verb>help)\Z/,
        /\A(?<verb>inventory)\Z/,
        /\A(?<verb>look)\Z/,
        /\A(?<verb>quit)\Z/,

        /\A(?<verb>buy) (?<noun>.*)\Z/,
        /\A(?<verb>drop) (?<noun>.*)\Z/,
        /\A(?<verb>go) (?<noun>.*)\Z/,
        /\A(?<verb>look at) (?<noun>.*)\Z/,
        /\A(?<verb>look in) (?<noun>.*)\Z/,
        /\A(?<verb>smash) (?<noun>.*)\Z/,
        /\A(?<verb>take) (?<noun>.*)\Z/,
        /\A(?<verb>unlock) (?<noun>.*)\Z/,

        /\A(?<verb>climb down) (?<noun>.*) with (?<prepositional_phrase>.*)\Z/,
      ]

      command = Command.new( nil, nil, nil )

      for pattern in verb_patterns
        match_data = pattern.match( translation )

        unless match_data.nil?
          if match_data.names.include?( "prepositional_phrase" )
            command = Command.new( match_data[:verb], match_data[:noun], match_data[:prepositional_phrase] )
          elsif match_data.names.include?( "noun" )
            command = Command.new( match_data[:verb], match_data[:noun] )
          else
            command = Command.new( match_data[:verb] )
          end
        end
      end


      command
    end
  end

end
