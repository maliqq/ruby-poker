Feature: Badugi hands
  Background:
    Given ranking badugi
  Scenario: Four card badugi
    Given hand As2h3d4c
    Then rank should be four_card
    Then high_cards should be 4
    Then value_cards should be A234

    Given hand TsJhQdKc
    Then rank should be four_card
    Then high_cards should be K
    Then value_cards should be TJQK

  Scenario: Three card badugi
    Given hand As2s3d4c
    Then rank should be three_card
    Then high_cards should be 4
    Then value_cards should be A34

    Given hand TcJcQdKh
    Then rank should be three_card
    Then high_cards should be K
    Then value_cards should be TQK

    Given hand AsAc2d3s
    Then rank should be three_card
    Then high_cards should be 3
    Then value_cards should be A23

    Given hand TcTsQhKd
    Then rank should be three_card
    Then high_cards should be K
    Then value_cards should be TQK

    Given hand TsJhQdQc
    Then rank should be three_card
    Then high_cards should be Q
    Then value_cards should be TJQ

  Scenario: One card badugi
    Given hand AsAhAdAc
    Then rank should be one_card
    Then high_cards should be A
    Then value_cards should be A

    Given hand As2s3s4s
    Then rank should be one_card
    Then high_cards should be A
    Then value_cards should be A

    Given hand ThJhQhKh
    Then rank should be one_card
    Then high_cards should be T
    Then value_cards should be T
