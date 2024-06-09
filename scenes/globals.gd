extends Node

const CARDS_IN_HAND = 5
const CARD_SPACING = 72
const SHORT_DELAY = 0.3

enum HANDS {
    ROYAL_FLUSH,
    STRAIGHT_FLUSH,
    FOUR_OF_A_KIND,
    FULL_HOUSE,
    FLUSH,
    STRAIGHT,
    THREE_OF_A_KIND,
    TWO_PAIR,
    PAIR,
    HIGH_CARD,
}

const HAND_NAMES = {
    HANDS.ROYAL_FLUSH: "Royal Flush",
    HANDS.STRAIGHT_FLUSH: "Straight Flush",
    HANDS.FOUR_OF_A_KIND: "Four of a Kind",
    HANDS.FULL_HOUSE: "Full House",
    HANDS.FLUSH: "Flush",
    HANDS.STRAIGHT: "Straight",
    HANDS.THREE_OF_A_KIND: "Three of a Kind",
    HANDS.TWO_PAIR: "Two Pair",
    HANDS.PAIR: "Pair",
    HANDS.HIGH_CARD: "High Card",
}
