Feature: giropayInitialTransaction
  As a guest user
  I want to make an initial transaction with giropay
  And to see that initial transaction was successful

  Background:
    Given I initialize shop system

  @woocommerce
  Scenario Outline: initial transaction
    And I activate "giropay" payment action <payment_action> in configuration
    And I prepare checkout with purchase sum "100" in shop system as "guest customer"
    And I see "Wirecard giropay"
    And I start "giropay" payment
    When I fill "giropay" fields in the shop
    And I place the order and continue "giropay" payment
    When I perform "giropay" actions outside of the shop
    Then I see successful payment
    And I check values for "giropay" and <transaction_type> transaction type
    And I check order state <order_state> in database

    Examples:
      | payment_action | transaction_type |  order_state  |
      |     "debit"    |      "debit"     | "processing"  |
