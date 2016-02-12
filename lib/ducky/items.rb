module Ducky

  class Item
    attr_reader :name, :description

    def initialize( name, description )
      @name = name
      @description = description
    end
  end

  class Rope < Item
    def initialize
      super( "rope", "It is 10 meters of thick, coarse rope. You imagine it could be used for sailing." )
    end
  end

  class Towel < Item
    def initialize
      super( "towel", "It is a thick, fluffy, yellow towel. Probably super moisture absorbant as well." )
    end
  end

  class BaseballHat < Item
    def initialize
      super( "baseball hat", "It is a red, white, and blue baseball hat. It is comfortably flexible. If you had a mirror it would probably look quite nice on you." )
    end
  end

  class Jar < Item
    def initialize
      super( "jar", "It is a large, clear, glass jar with a metal lid. Inside floating in some clear liquid is a squishy-looking brain." )
    end
  end

  class Gem < Item
    def initialize
      super( "gem", "It is about the size of your thumb but it sparkles brilliantly in the light." )
    end
  end

  class Necklace < Item
    def initialize
      super( "necklace", "A fragile, silver necklace with a silver lion pendant." )
    end
  end

end
