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
