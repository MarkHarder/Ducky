module Ducky
  # A collection of utility functions to format output to a terminal
  module TerminalUtilities
    # clear the terminal
    def self.clear
      # ASCII escape sequences
      print "\e[2J\e[24H"
    end

     # wrap any number of lines
    def self.format( text, wrap_length=80 )
      # split the text at all the newlines
      lines = text.split( "\n", -1 )
      # format each line
      formatted_lines = lines.collect { |line| format_line( line, wrap_length ) }
      # join all the lines and reinsert the newlines
      formatted_lines.join( "\n" )
    end

    private
    # wrap a line
    def self.format_line( line, wrap_length=80 )
      output = [""]
      # split the line on any white space
      # each whitespace will be replaced with a single space
      words = line.split( /\s/, -1 )

      # until every word has been placed,
      #   test the next word
      #   if it is too large to put on a single line,
      #     start a new line and append it on the end
      #   if it is not too long, 
      #     append it to the end of the current line
      #   add a space at the end if there are words remaining
      until words.empty?
        w = words.shift
        output.push( "" ) if output.last.length + w.length + 1 >= wrap_length
        output[-1] += w
        output[-1] += " " unless words.empty?
      end

      # join the formatted lines with a newline
      output.join( "\n" )
    end
  end
end
