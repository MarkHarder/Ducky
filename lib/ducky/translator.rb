require "ducky/command"

module Ducky

  # A class to translate user input to game commands
  # This is done in several steps
  #   all non-word, non-whitespace, non-digit characters are removed
  #   the input is downcased and split into words
  #   abbreviations and synonyms are replaced
  #   the words and joined again with spaces into a translated text
  #   multi-word replacements are then performed on this text
  #   if the verb is 'go' it checks if a valid direction is the noun
  #     if not an error is displayed
  #     the input is blanked
  #   check that the input is a valid command using a phrase-based regexp
  #
  # Translation ensures that input is changed:
  #   to a form the game can understand
  #   to a single command per action
  # For example
  #   "take yellow towel" and "pick up towel"
  #   would be translated to "take yellow towel" and "take towel" respectively
  #   the game will then decide if "yellow towel" or "towel" refer to anything
  # The 'go' command has special forms
  #   'n', 'walk north', 'go n', 'north', etc.
  #   all translate to 'go north'
  #   this is the only form you can list a noun with no verb
  #     the verb gets added in the multi-word replacements if it is missing
  module Translator
    # phrases used as the basis for regexps
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

      # replace abbreviations and synonyms
      words.collect! do |word|
        if Translator.abbreviations.keys.include?( word )
          Translator.abbreviations[ word ]
        elsif Translator.synonyms.keys.include?( word )
          Translator.synonyms[ word ]
        else
          word
        end
      end

      # join the words together
      translation = words.join( " " )

      # replace multi-word phrases
      translation.gsub!( "pick up", "take" )
      translation.gsub!( "climb into", "climb down" )
      translation.gsub!( "put down", "drop" )
      translation = "go north" if translation == "north"
      translation = "go south" if translation == "south"
      translation = "go east" if translation == "east"
      translation = "go west" if translation == "west"
      translation = "go up" if translation == "up"
      translation = "go down" if translation == "down"

      # check if a valid direction is given
      if translation.start_with?( "go" )
        possible_directions = ["north", "south", "west", "east", "up", "down"]
        possible_commands = possible_directions.collect { |d| "go #{d}" }

        # print an error if an invalid direction was given
        unless possible_commands.include?( translation )
          puts "You must enter a valid direction to go."
          translation = ""
        end
      end

      # check if the text fits a phrase pattern
      # if it does:
      #   store the verb, noun, and object information as necessary
      # if it doesn't:
      #   return the nil command
      command = Command.new( nil, nil, nil )

      for phrase in Translator.phrases
        # make the regexp
        pattern = make_pattern( phrase )
        # get the data from the regexp match
        # if the input is valid information will the stored in command
        match_data = pattern.match( translation )

        unless match_data.nil?
          # check if there is a prepositional phrase
          if match_data.names.include?( "object" )
            command = Command.new( match_data[:verb], match_data[:noun], match_data[:object] )
          # if not, check if there is a noun
          elsif match_data.names.include?( "noun" )
            command = Command.new( match_data[:verb], match_data[:noun] )
          # if not, it must be a single verb command
          else
            command = Command.new( match_data[:verb] )
          end
        end
      end

      command
    end

    # make a pattern to check if user input is a valid command
    # A pattern should have 1 of 3 forms
    #   a single-verb command
    #     /\A(?<verb>look)\Z/
    #     input phrase: 'look'
    #     should match: "look"
    #   a verb/noun command
    #     /\A(?<verb>take) (?<noun>.*)\Z/
    #     input phrase: 'look [noun]'
    #     should match: "take rope", "take baseball hat"
    #   a verb, noun, and prepositional phrase
    #     /\A(?<verb>climb down) (?<noun>.*) with (?<object>.*)\Z/
    #     input phrase: 'climb down [noun] with [object]'
    #     should match: "climb down hole with rope"
    # A pattern must start with a verb, after that you can add:
    #   bracketed content (e.g. [noun])
    #   non-bracketed content (e.g. ' with ')
    # The pattern always starts with \A and ends with \Z
    #   this ensures the entire string is matched
    # Bracketed content is always matched with .*
    #
    # This method will also make regexps for phrases not used in this game
    #   bracked variables can be given an alphanumeric name
    #     /\A(?<verb>look at) (?<item_name>.*)\Z/
    #     input phrase: 'look at [item_name]'
    #     should match: "look at rope", "look at baseball hat"
    #     /\A(?<verb>ride) (?<animal>.*)\Z/
    #     input phrase: 'ride [animal]'
    #     should match: "ride horse", "ride large elephant"
    #   it should be possible to add any number of brackets
    #     /\A(?<verb>paint) (?<target>.*) on (?<place>.*) with (?<object>.*)\Z/
    #     input phrase: 'paint [target] on [place] with [object]
    #     should match: "paint smiley face on canvas with brush"
    def make_pattern( phrase )
      # seperate the parts inside square brackets from the rest of the phrase

      # bracket contents (not including the brackets)
      blanks = phrase.scan( /\[(.*?)\]/ ).flatten
      # portions outside brackets
      #   (including whitespace, not including the brackets)
      non_blanks = phrase.split( /\s?\[.*?\]\s?/, -1 )

      # the number of brackets determines the form
      case blanks.length
      when 0
        # a single-verb checking regexp
        /\A(?<verb>#{non_blanks[ 0 ]})\Z/
      when 1
        # verb/noun checking regexp
        /\A(?<verb>#{non_blanks[ 0 ]}) (?<#{blanks[ 0 ]}>.*)\Z/
      else
        # a verb with multiple nouns and prepositional phrases checking regexp
        # must start with a verb
        pattern = "\\A(?<verb>#{non_blanks[ 0 ]}) (?<#{blanks[ 0 ]}>.*)"
        # add the rest
        1.upto( blanks.length - 1 ) do |i|
          pattern += " #{non_blanks[ i ]} (?<#{blanks[ i ]}>.*)"
        end
        # if the phrase ends in non-bracketed content, append that content
        if non_blanks.length > blanks.length && non_blanks.last != "" && non_blanks.last != ""
          pattern += " #{non_blanks[ non_blanks.length - 1 ]}"
        end
        pattern += "\\Z"
        Regexp.new( pattern )
      end
    end
  end

end
