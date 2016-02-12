module Ducky

  class Coordinate
    attr_reader :x, :y, :z

    def initialize( x, y, z=0 )
      @x = x
      @y = y
      @z = z
    end

    def north
      Coordinate.new( @x, @y+1, @z )
    end

    def south
      Coordinate.new( @x, @y-1, @z )
    end

    def east
      Coordinate.new( @x+1, @y, @z )
    end

    def west
      Coordinate.new( @x-1, @y, @z )
    end

    def down
      Coordinate.new( @x, @y, @z-1 )
    end

    def up
      Coordinate.new( @x, @y, @z+1 )
    end

    def eql?( other_coordinate )
      other_coordinate.x == @x && other_coordinate.y == @y && other_coordinate.z == @z
    end

    def hash
      [@x, @y, @z].hash
    end
  end

end
