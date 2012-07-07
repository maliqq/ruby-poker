Feature: High hands
  Background:
    Given ranking high
    
  Scenario: Straight flush
    Given hand AsKsQsJsTs
    Then rank should be straight_flush
    And high_cards should be A
    And value_cards should be AKQJT
    And no kicker_cards

    Given hand Ad2d3d4d5d
    Then rank should be straight_flush
    And high_cards should be 5
    And value_cards should be 5432A
    And no kicker_cards

    Given hand 4s5s6s7s8s9sTs
    Then rank should be straight_flush
    And high_cards should be T
    And value_cards should be T9876
    And no kicker_cards

  Scenario: Four kind
    Given hand QsQhQdQcJc
    Then rank should be four_kind
    And high_cards should be Q
    And value_cards should be QQQQ
    And kicker_cards should be J

    Given hand 2s2h2d2c4d
    Then rank should be four_kind
    And high_cards should be 2
    And value_cards should be 2222
    And kicker_cards should be 4

  Scenario: Full house
    Given hand AsAdAcKsKd
    Then rank should be full_house
    And high_cards should be AK
    And value_cards should be AAAKK
    And no kicker_cards

    Given hand JsJdJc7s7d7c
    Then rank should be full_house
    And high_cards should be J7
    And value_cards should be JJJ77
    And no kicker_cards

  Scenario: Flush
    Given hand AsKsQs8s9s3s
    Then rank should be flush
    And high_cards should be A
    And value_cards should be AKQ98
    And no kicker_cards

  Scenario: Straight
    Given hand KsQdJsTd9s
    Then rank should be straight
    And high_cards should be K
    And value_cards should be KQJT9
    And no kicker_cards

  Scenario: Three kind
    Given hand 5s5d5c9s8d2c
    Then rank should be three_kind
    And high_cards should be 5
    And value_cards should be 555
    And kicker_cards should be 98

  Scenario: Two pair
    Given hand 2s2d5s5dKh
    Then rank should be two_pair
    And high_cards should be 52
    And value_cards should be 5522
    And kicker_cards should be K

    Given hand 5s5d6s6d7h7c
    Then rank should be two_pair
    And high_cards should be 76
    And value_cards should be 7766
    And kicker_cards should be 5

  Scenario: One pair
    Given hand 3s3d7h8h9dKc
    Then rank should be one_pair
    And high_cards should be 3
    And value_cards should be 33
    And kicker_cards should be K98

  Scenario: High card
    Given hand QhTh8h7d4c2h
    Then rank should be high_card
    And high_cards should be Q
    And value_cards should be Q
    And kicker_cards should be T874
