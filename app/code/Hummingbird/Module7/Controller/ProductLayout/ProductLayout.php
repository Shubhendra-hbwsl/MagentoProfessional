<?php 

namespace Hummingbird\Module7\Controller\ProductLayout;


use Magento\Framework\Controller\ResultInterface;
use Magento\Framework\App\RequestInterface;
use Magento\Catalog\Api\ProductRepositoryInterface;
use Magento\Store\Model\StoreManagerInterface;

 class ProductLayout {
    private $request;
    private $productRepository;
    private $storeManager;

    public function __construct(
        RequestInterface $request,
        ProductRepositoryInterface $productRepository,
        StoreManagerInterface $storeManager
    ) {
        $this->request = $request;
        $this->productRepository = $productRepository;
        $this->storeManager = $storeManager;
    }

    public function afterExecute(\Magento\Catalog\Controller\Product\View $subject, $resultPage)
    {
        if ($resultPage instanceof ResultInterface)
        {
            $productId = (int) $this->request->getParam('id');
            if ($productId)
            {
                    $product = $this->productRepository->getById($productId, false, $this->storeManager->getStore()->getId());
                    if ($product)
                    {
                        // DEBUG: this will override the custom layout set to 2 columns right in module 5 for product view page
                        $pageConfig = $resultPage->getConfig();
                        $pageConfig->setPageLayout('3columns'); 
                    }
            }
        }
        return $resultPage;
    }
 }