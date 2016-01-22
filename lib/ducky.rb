require "ducky/player"
require "ducky/version"
require "ducky/world"

module Ducky
  WORLD = World.new
  PLAYER = Player.new

  class DuckyGame
    def start
      clear
      puts intro

      puts WORLD.room_at( PLAYER.location ).description
      loop do
        print "> "
        command = translate( gets.chomp )

        if command == "quit"
          exit_game
        elsif command == "look"
          puts WORLD.room_at( PLAYER.location ).description
        end
      end
    end

    def exit_game
      puts "Game Over"
      exit
    end

    private
    # the string that introduces the game
    def intro
      <<~STR
      DUCKY
      --------
      v#{VERSION}
      
      STR
    end

    # clear the terminal
    def clear
      # ASCII escape sequences
      print "\e[2J\e[24H"
    end

    # translate input into game-usable commands
    def translate( text )
      abbreviations = {
        "q" => "quit",
      }

      words = text.split( /\s+/ )

      words.collect! do |word|
        if abbreviations.keys.include?( word )
          abbreviations[ word ]
        else
          word
        end
      end

      words.join( " " )
    end
  end
end
