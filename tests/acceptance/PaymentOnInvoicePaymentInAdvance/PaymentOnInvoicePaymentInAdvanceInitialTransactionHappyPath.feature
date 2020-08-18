Feature: PaymentOnInvoice/PaymentInAdvanceInitialTransactionHappyPath
  As a guest user
  I want to make an initial transaction with PaymentOnInvoice/PaymentInAdvance
  And to see that initial transaction was successful

  Background:
    Given I initialize shop system

  @woocommerce
  Scenario Outline: initial transaction
    And I activate "PaymentOnInvoice/PaymentInAdvance" payment action <payment_type> in configuration
    And I prepare checkout with purchase sum <amount> in shop system as "registered customer"
    And I see "Wirecard Payment On Invoice / Payment In Advance"
    And I start "PaymentOnInvoice/PaymentInAdvance" payment
    When I place the order and continue "PaymentOnInvoice/PaymentInAdvance" payment
    Then I see successful payment
    And I check values for "PaymentOnInvoice/PaymentInAdvance" and <transaction_type> transaction type
    And I check order state <order_state> in database

    Examples:
      | payment_type         | amount | transaction_type | order_state |
      | "Payment On Invoice" | 100    | "authorization"  | on-hold  |
      | "Payment In Advance" | 100    | "authorization"  | on-hold  |
