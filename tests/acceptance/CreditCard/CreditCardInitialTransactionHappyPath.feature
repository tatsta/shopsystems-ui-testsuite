Feature: CreditCardInitialTransactionHappyPath
  As a guest user
  I want to make an initial transaction with a Credit Card
  And to see that initial transaction was successful

  Background:
    Given I initialize shop system

  @woocommerce @prestashop @magento2
  Scenario Outline: initial transaction Non 3DS
    Given I activate "CreditCard" payment action <payment_action> in configuration
    And I prepare checkout with purchase sum <amount> in shop system as "guest customer"
    And I see "Wirecard Credit Card"
    And I start "CreditCard" payment
    And I place the order and continue "CreditCard" payment
    When I fill "CreditCard" fields in the shop
    Then I see successful payment
    And I check values for "CreditCard" and <transaction_type> transaction type
    And I check order state <order_state> in database

    Examples:
      | payment_action  | amount | transaction_type | order_state |
      |    "reserve"    |  "20"  |  "authorization" | authorized  |
      |      "pay"      |  "20"  |    "purchase"    | processing  |

  @woocommerce @prestashop @magento2 @major @minor @patch
  Scenario Outline: initial transaction 3DS
    Given I activate "CreditCard" payment action <payment_action> in configuration
    And I prepare checkout with purchase sum <amount> in shop system as "guest customer"
    And I see "Wirecard Credit Card"
    And I start "CreditCard" payment
    And I place the order and continue "CreditCard" payment
    When I fill "CreditCard" fields in the shop
    And I perform "CreditCard" actions outside of the shop
    Then I see successful payment
    And I check values for "CreditCard" and <transaction_type> transaction type
    And I check order state <order_state> in database

    Examples:
      | payment_action  | amount | transaction_type | order_state |
      |    "reserve"    |  "100" |  "authorization" | authorized  |
      |      "pay"      |  "100" |    "purchase"    | processing  |
