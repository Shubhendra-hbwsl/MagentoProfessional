<?php 

namespace Hummingbird\Module7\Block;

use Magento\Framework\View\Element\Template;
use Magento\Framework\View\Element\Template\Context;

class TwoColsBlock extends Template{
    public function __construct(Context $context){
        parent::__construct($context);
    }

    // create some function to send message to template file.
    public function getTwoColsMessage(){
        return __('Sample Heading message for 2 cols page layout');
    }
}