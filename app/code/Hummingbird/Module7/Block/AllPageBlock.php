<?php 

namespace Hummingbird\Module7\Block;

use Magento\Framework\View\Element\Template;
use Magento\Framework\View\Element\Template\Context;

class AllPageBlock extends Template{

    public function __construct(Context $context){
        parent::__construct($context);
    }

    public function getUniversalMessage(){
        return __('This message will be displayed on every page!');
    }

}
