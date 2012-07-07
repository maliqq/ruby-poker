Feature: High hands
  Background:
    Given ranking high
  Scenario: Straight flush
    Given hand AsKsQsJsTs
    Then rank should be straight_flush
    Then high_cards should be A
    Then value_cards should be AKQJT
    Then kicker_cards are empty

    Given hand Ad2d3d4d5d
    Then rank should be straight_flush
    Then high_cards should be 5
    Then value_cards should be 5432A
    Then kicker_cards are empty

  Scenario: Four kind
    Given hand QsQhQdQcJc
    Then rank should be four_kind
    Then high_cards should be Q
    Then value_cards should be QQQQ
    Then kicker_cards should be J

    Given hand 2s2h2d2c4d
    Then rank should be four_kind
    Then high_cards should be 2
    Then value_cards should be 2222
    Then kicker_cards should be 4
