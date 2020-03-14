<?php

class MDAMPProductModuleFrontController extends ModuleFrontController
{
    public $display_header = false;
    public $display_footer = false;
    public $display_column_left = false;
    public $display_column_right = false;

    private $product = null;
    private $productAMP = [];
    private $product_images = [];

    public function init()
    {
        parent::init();
        $this->product = new Product((int) Tools::getValue('id'), false, $this->context->language->id);
        if (!Validate::isLoadedObject($this->product)) {
            Tools::redirect($this->context->link->getPageLink('PageNotFoundController'));
        }
    }

    /**
     * @throws PrestaShopException
     */
    public function initContent()
    {
        /*
         * Hydrate Product Array
         */
        $this->productAMP['id'] = $this->product->id;
        $this->productAMP['name'] = $this->product->name;
        $this->productAMP['clean_description'] = DescriptionHelper::cleanDescription($this->product->description);
        $this->productAMP['link_rewrite'] = $this->product->link_rewrite;
        $this->productAMP['reference'] = $this->product->reference;
        $this->productAMP['features'] = $this->product->getFrontFeatures($this->context->language->id);

        $this->assignImages();
        $this->assignPrice();

        $this->context->smarty->assign([
            'productAMP' => $this->productAMP,
            'images' => $this->product_images,
            'link' => $this->context->link,
            'css' => Media::minifyCSS(Tools::file_get_contents(_PS_MODULE_DIR_ . 'mdamp/views/css/front.css')),
            'cover' => Product::getCover((int) $this->product->id),
            'canonical' => $this->context->link->getProductLink($this->product->id, $this->product->link_rewrite),
            'meta' => Meta::getProductMetas($this->product->id, $this->context->language->id, 'product'),
            'addToCartLink' => $this->context->link->getPageLink(
                'cart',
                true,
                $this->context->language->id,
                array(
                    'add' => 1,
                    'id_product' => $this->product->id,
                    'token' => Tools::getToken(false),
                ),
                false,
                $this->context->shop->id
            ),
        ]);

        if (version_compare(_PS_VERSION_, '1.7.0', '>=')) {
            $this->setTemplate('module:mdamp/views/templates/front/product_17.tpl');
        } else {
            $this->setTemplate('product.tpl');
        }

        parent::initContent();
    }

    private function assignImages()
    {
        foreach ($this->product->getImages($this->context->language->id) as $image) {
            $this->product_images[(int) $image['id_image']] = $image;
        }

        $size = Image::getSize(ImageType::getFormatedName('large'));

        if (count($this->product_images)) {
            $this->context->smarty->assign('images', $this->product_images);
        }

        $this->context->smarty->assign(
            array(
                'imgWidth' => (int) $size['width'],
                'mediumSize' => Image::getSize(ImageType::getFormatedName('medium')),
                'largeSize' => Image::getSize(ImageType::getFormatedName('large')),
                'homeSize' => Image::getSize(ImageType::getFormatedName('home')),
            )
        );
    }

    /**
     * Assign price to $this->productAMP
     */
    private function assignPrice()
    {
        $priceDisplay = Product::getTaxCalculationMethod((int) $this->context->cookie->id_customer);
        if (!$priceDisplay || $priceDisplay == 2) {
            $this->productAMP['price'] = $this->product->getPrice(true, null, 2, null, false, true);
            $this->productAMP['price_old'] = $this->product->getPrice(true, null, 2, null, false, false);
        } elseif ($priceDisplay == 1) {
            $this->productAMP['price'] = $this->product->getPrice(false, null, 2, null, false, true);
            $this->productAMP['price_old'] = $this->product->getPrice(false, null, 2, null, false, true);
        }

        if ($this->productAMP['price'] == $this->productAMP['price_old']) {
            $this->productAMP['price'] = Tools::displayPrice($this->productAMP['price']);
            $this->productAMP['price_old'] = null;
        } else {
            $this->productAMP['price'] = Tools::displayPrice($this->productAMP['price']);
            $this->productAMP['price_old'] = Tools::displayPrice($this->productAMP['price_old']);
        }
    }

    /**
     * @return bool
     */
    public function setMedia()
    {
        return false;
    }

    /**
     * Renders controller templates and generates page content
     *
     * @param array|string $content Template file(s) to be rendered
     *
     * @throws Exception
     * @throws SmartyException
     */
    protected function smartyOutputContent($content)
    {
        if (!Configuration::get('PS_JS_DEFER')) {
            parent::smartyOutputContent($content);

            return;
        }

        Configuration::set('PS_JS_DEFER', 0);

        parent::smartyOutputContent($content);

        Configuration::set('PS_JS_DEFER', 1);
    }
}