module Ducky

  class Item
    attr_reader :name, :description

    def initialize( name, description, synonyms )
      @name = name
      @description = description
      @synonyms = synonyms
    end

    def identified_by?( text )
      @synonyms.include?( text )
    end
  end

  class Rope < Item
    def initialize
      super( "rope", "It is 10 meters of thick, coarse rope. You imagine it could be used for sailing.", ["rope"] )
    end
  end

  class Towel < Item
    def initialize
      super( "towel", "It is a thick, fluffy, yellow towel. Probably super moisture absorbent as well.", ["yellow towel", "towel"] )
    end
  end

  class BaseballHat < Item
    def initialize
      super( "baseball hat", "It is a red, white, and blue baseball hat. It is comfortably flexible. If you had a mirror it would probably look quite nice on you.", ["baseball hat", "hat"] )
    end
  end

  class Jar < Item
    def initialize
      super( "jar", "It is a large, clear, glass jar with a metal lid. Inside floating in some clear liquid is a squishy-looking brain.", ["jar", "brain jar", "brain", "glass jar"] )
    end
  end

  class Gem < Item
    def initialize
      super( "gem", "It is about the size of your thumb but it sparkles brilliantly in the light.", ["gem"] )
    end
  end

  class Necklace < Item
    def initialize
      super( "necklace", "A fragile, silver necklace with a silver lion pendant.", ["necklace", "silver necklace", "pendant"] )
    end
  end

  class Coin < Item
    def initialize
      super( "coin", "A thick gold coin. Possibly a Spanish doubloon.", ["coin", "gold coin", "doubloon", "spanish doubloon"] )
    end
  end

  class GlassShard < Item
    def initialize
      super( "glass shard", "A fairly large, jagged piece of glass. It looks sharp.", ["shard", "glass shard", "glass", "piece of glass", "jagged shard", "jagged glass shard", "jagged glass", "jagged piece of glass"] )
    end
  end

  class Brain < Item
    def initialize
      super( "brain", "It is cold and wet. Not exactly an appealing object.", ["brain"] )
    end
  end

  class SoftDrink < Item
    def initialize
      super( "soft drink", "A somewhat luke-warm, unappetizing Red Lantern soft drink.", ["soft drink", "soda", "pop", "cola", "coke"] )
    end
  end

  class Key < Item
    def initialize
      super( "key", "The key to the exit. A large, metal key.", ["key", "metal key", "large key", "large metal key"] )
    end
  end

end
