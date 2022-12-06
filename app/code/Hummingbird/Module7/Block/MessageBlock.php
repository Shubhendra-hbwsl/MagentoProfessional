<?php

namespace Hummingbird\Module7\Block;

use Magento\Framework\View\Element\Template;
use Magento\Framework\View\Element\Template\Context;

class MessageBlock extends Template{
    public function __construct(Context $context){ 
        parent::__construct($context);
    }

    public function getMessage(){
        $message = "Custom message for module 7";
        return __($message);
    }

    public function _afterToHtml($html){
        $anotherMessage = '<h3 style="color: red;"><em>Message from _afterToHtml</em></h3>';
        return $html . $anotherMessage;
    }
}