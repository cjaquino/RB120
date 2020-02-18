class Card
  FACE_VALUES = {'Jack' => 11, 'Queen' => 12, 'King' => 13, 'Ace' => 14}
  SUIT_VALUES = {'Spades' => 4, 'Hearts' => 3, 'Clubs' => 2, 'Diamonds' => 1}

  attr_reader :rank, :suit

  include Comparable

  def initialize(rank, suit)
    @rank = rank
    @suit = suit
  end

  def to_s
    "#{rank} of #{suit}"
  end

  def <=>(other)
    if rank == other.rank
      SUIT_VALUES[suit] <=> SUIT_VALUES[other.suit]
    else
      rank_value <=> other.rank_value
    end
  end

  def rank_value
    FACE_VALUES.fetch(rank, rank)
  end
end