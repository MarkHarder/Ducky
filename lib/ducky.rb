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
        elsif command.start_with?( "go" )
          x = PLAYER.location[0]
          y = PLAYER.location[1]
          z = PLAYER.location[2]

          if command == "go north" && !WORLD.room_at([x, y+1, z]).nil?
            puts "You go north."
            PLAYER.location[1] += 1
            puts WORLD.room_at( PLAYER.location ).description
          elsif command == "go south" && !WORLD.room_at([x, y-1, z]).nil?
            puts "You go south."
            PLAYER.location[1] -= 1
            puts WORLD.room_at( PLAYER.location ).description
          elsif command == "go east" && !WORLD.room_at([x+1, y, z]).nil?
            puts "You go east."
            PLAYER.location[0] += 1
            puts WORLD.room_at( PLAYER.location ).description
          elsif command == "go west" && !WORLD.room_at([x-1, y, z]).nil?
            puts "You go west."
            PLAYER.location[0] -= 1
            puts WORLD.room_at( PLAYER.location ).description
          end
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
