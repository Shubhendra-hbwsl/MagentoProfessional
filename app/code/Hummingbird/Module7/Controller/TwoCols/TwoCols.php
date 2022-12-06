<?php 

namespace Hummingbird\Module7\Controller\TwoCols;

use Magento\Framework\App\Action\HttpGetActionInterface;
use \Magento\Framework\View\Result\PageFactory;

class TwoCols implements HttpGetActionInterface{
    protected $pageFactory;

    public function __construct(PageFactory $pageFactory){
        $this->pageFactory = $pageFactory;
    }

    public function execute()
    {
        // add the file name of layout to load it.
        return $this->pageFactory->create()->addHandle('twocols_twocols_twocols');    
    }
}