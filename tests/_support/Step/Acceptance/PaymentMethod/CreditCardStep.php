<?php

namespace Step\Acceptance\PaymentMethod;

use Facebook\WebDriver\Exception\TimeOutException;
use Facebook\WebDriver\Exception\UnknownServerException;
use Step\Acceptance\iPerformFillPaymentFields;
use Step\Acceptance\iPerformPayment;
use Exception;

/**
 * Class CreditCardStep
 * @package Step\Acceptance\PaymentMethod
 */
class CreditCardStep extends GenericPaymentMethodStep implements iPerformPayment, iPerformFillPaymentFields
{
    const STEP_NAME = 'CreditCard';

    /**
     * @throws Exception
     */
    public function fillFieldsInTheShop(): void
    {
        $this->switchToCreditCardUIFrame();
        try {
            $this->preparedFillField($this->getLocator()->last_name, $this->getPaymentMethod()->getLastName(), 60);
        } catch (TimeOutException $e) {
            $this->switchToIFrame();
            $this->switchToCreditCardUIFrame();
            $this->preparedFillField($this->getLocator()->last_name, $this->getPaymentMethod()->getLastName(), 60);
        }
        $this->fillField($this->getLocator()->card_number, $this->getPaymentMethod()->getCardNumber());
        $this->fillField($this->getLocator()->cvv, $this->getPaymentMethod()->getCvv());
        $this->fillField($this->getLocator()->expiry_date, $this->getPaymentMethod()->getValidUntil());
        $this->switchToIFrame();
    }

    /**
     * @throws Exception
     */
    public function performPaymentMethodActionsOutsideShop() : void
    {
        $this->preparedFillField($this->getLocator()->password, $this->getPaymentMethod()->getPassword());
        $this->click($this->getLocator()->continue_button);
    }

    /**
     * Method switchToCreditCardUIFrame
     * @return boolean
     * @throws Exception
     */
    public function switchToCreditCardUIFrame()
    {
        //wait for frame to load
        $this->waitUntil(
            10,
            [$this, 'waitUntilIframeLoaded'],
            [$this->getLocator()->frame]
        );

        //check if frame is loaded
        $wirecardFrame = $this->executeJS(
            'return document.querySelector("#' . $this->getLocator()->frame . '")'
        );
        if ($wirecardFrame === null) {
            return false;
        }
        $this->assertNotEquals($wirecardFrame, null, 'Is IFrame loaded?');

        //get wirecard seemless frame name
        $wirecardFrameName = $this->executeJS(
            'return document.querySelector("#' . $this->getLocator()->frame . '").getAttribute("name")'
        );
        $this->switchToIFrame($wirecardFrameName);
        return true;
    }
}
