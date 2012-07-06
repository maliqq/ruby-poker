Feature: Badugi hands
  Scenario: Four card badugi
    Given hand As2h3d4c
    When detect
    Then rank should be four_card
    Then high_cards should be 4
    Then value_cards should be A234

    Given hand TsJhQdKc
    When detect
    Then rank should be four_card
    Then high_cards should be K
    Then value_cards should be TJQK

  Scenario: Three card badugi
    Given hand As2s3d4c
    When detect
    Then rank should be three_card
    Then high_cards should be 4
    Then value_cards should be A34

    Given hand TcJcQdKh
    When detect
    Then rank should be three_card
    Then high_cards should be K
    Then value_cards should be TQK

    Given hand AsAc2d3s
    When detect
    Then rank should be three_card
    Then high_cards should be 3
    Then value_cards should be A23

    Given hand TcTsQhKd
    When detect
    Then rank should be three_card
    Then high_cards should be K
    Then value_cards should be TQK

    Given hand TsJhQdQc
    When detect
    Then rank should be three_card
    Then high_cards should be Q
    Then value_cards should be TJQ
