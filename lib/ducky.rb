require "ducky/version"

module Ducky
  class DuckyGame
    def start
      clear
      puts intro

      loop do
        print "> "
        command = gets.chomp
        clear

        if command == "quit"
          exit_game
        end
      end
    end

    def exit_game
      puts "Game Over"
      exit
    end

    private
    def intro
      <<~STR
      DUCKY
      --------
      v#{VERSION}
      
      STR
    end

    def clear
      print "\e[2J\e[24H"
    end
  end
end
