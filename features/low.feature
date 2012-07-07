Feature: Low hands
  Scenario: Ace to five low
    Given ace_five low Ad2d3d4d5d
    Then rank should be low
    And high_cards should be 5
    And value_cards should be A2345
    And no kicker_cards

  Scenario: Ace to five low with 8 qualifier
    Given ace_five8 low As3s4d7d8d
    Then rank should be low
    And high_cards should be 8
    And value_cards should be A3478
    And no kicker_cards

  Scenario: Ace to six low
    Given ace_six low As2s3h4d6d
    Then rank should be low
    And high_cards should be 6
    And value_cards should be A2346
    And no kicker_cards

  Scenario: Deuce to six low
    Given deuce_six low 2s3s4s5s6s
    Then rank should be low
    And high_cards should be 6
    And value_cards should be 23456
    And no kicker_cards

  Scenario: Deuce to seven low
    Given deuce_seven low 2s3s4d5s7s
    Then rank should be low
    And high_cards should be 7
    And value_cards should be 23457
    And no kicker_cards
