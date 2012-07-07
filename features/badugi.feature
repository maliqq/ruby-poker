Feature: Badugi hands
  Background:
    Given ranking badugi
  Scenario: Four card badugi
    Given hand As2h3d4c
    Then rank should be four_card
    And high_cards should be 4
    And value_cards should be A234

    Given hand TsJhQdKc
    Then rank should be four_card
    And high_cards should be K
    And value_cards should be TJQK

  Scenario: Three card badugi
    Given hand As2s3d4c
    Then rank should be three_card
    And high_cards should be 4
    And value_cards should be A34

    Given hand TcJcQdKh
    Then rank should be three_card
    And high_cards should be K
    And value_cards should be TQK

    Given hand AsAc2d3s
    Then rank should be three_card
    And high_cards should be 3
    And value_cards should be A23

    Given hand TcTsQhKd
    Then rank should be three_card
    And high_cards should be K
    And value_cards should be TQK

    Given hand TsJhQdQc
    Then rank should be three_card
    And high_cards should be Q
    And value_cards should be TJQ

  Scenario: Two card badugi
    Given hand As2s3c4c
    Then rank should be two_card
    And high_cards should be 3
    And value_cards should be A3

    Given hand TsJsQcKc
    Then rank should be two_card
    And high_cards should be Q
    And value_cards should be TQ

    Given hand As2d2c3s
    Then rank should be two_card
    And high_cards should be 2
    And value_cards should be A2

    Given hand As2s2d3d
    Then rank should be two_card
    And high_cards should be 2
    And value_cards should be A2

    Given hand As2s3d3c
    Then rank should be two_card
    And high_cards should be 3
    And value_cards should be A3

  Scenario: One card badugi
    Given hand AsAhAdAc
    Then rank should be one_card
    And high_cards should be A
    And value_cards should be A

    Given hand As2s3s4s
    Then rank should be one_card
    And high_cards should be A
    And value_cards should be A

    Given hand ThJhQhKh
    Then rank should be one_card
    And high_cards should be T
    And value_cards should be T
