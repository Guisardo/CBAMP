<!doctype html>
<html amp>
    <head>
        <meta charset="utf-8">
        <script async src="https://cdn.ampproject.org/v0.js"></script>
        <title>
            {$meta.meta_title}
        </title>
        <link rel="canonical" href="{$canonical}">
        <meta name="viewport" content="width=device-width,minimum-scale=1,initial-scale=1">
        {literal}
            <style amp-boilerplate>body{-webkit-animation:-amp-start 8s steps(1,end) 0s 1 normal both;-moz-animation:-amp-start 8s steps(1,end) 0s 1 normal both;-ms-animation:-amp-start 8s steps(1,end) 0s 1 normal both;animation:-amp-start 8s steps(1,end) 0s 1 normal both}@-webkit-keyframes -amp-start{from{visibility:hidden}to{visibility:visible}}@-moz-keyframes -amp-start{from{visibility:hidden}to{visibility:visible}}@-ms-keyframes -amp-start{from{visibility:hidden}to{visibility:visible}}@-o-keyframes -amp-start{from{visibility:hidden}to{visibility:visible}}@keyframes -amp-start{from{visibility:hidden}to{visibility:visible}}</style>
            <noscript>
                <style amp-boilerplate>body{-webkit-animation:none;-moz-animation:none;-ms-animation:none;animation:none}</style>
            </noscript>
        {/literal}
        <script async custom-element="amp-carousel" src="https://cdn.ampproject.org/v0/amp-carousel-0.1.js"></script>
        <script async custom-element="amp-analytics" src="https://cdn.ampproject.org/v0/amp-analytics-0.1.js"></script>
        <script async custom-element="amp-social-share" src="https://cdn.ampproject.org/v0/amp-social-share-0.1.js"></script>
        <link href="https://fonts.googleapis.com/css?family=Open+Sans:300,400,700&display=swap" rel="stylesheet"> 
        
        <style amp-custom>
            {$css nofilter}
        </style>        
    </head>
    <body>
        {hook h='ampAnalytics' mod='cbamp'}
        <div class="page-body-amp">
            <div class="header-column-amp">
                <a href="{$urls.pages.index}">
                    <amp-img src="{$shop.logo}"
                             width="250"
                             height="99"
                             id="shop-logo-amp"
                             alt="{l s='Shop logo' mod='cbamp'}">
                    </amp-img>
                </a>
            </div>
            <div class="page-content-amp">
                <div id="product-image-amp">
                    <amp-carousel width="400"
                            height="300"
                            layout="responsive"
                            type="slides"
                            autoplay
                            delay="2000">
                        <amp-img
                                src="{$link->getImageLink($productAMP.id, $cover.id_image, 'large_default')}"
                                width="{$largeSize['width']}"
                                height="{$largeSize['height']}"
                                alt="{if !empty($cover.legend)}{$cover.legend}{else}{$productAMP.name}{/if}"
                                layout="responsive">
                        </amp-img>
                        {if isset($images) && count($images) > 0}
                            {foreach from=$images item=image name=thumbnails}
                                {assign var=imageIds value="`$productAMP.id`-`$image.id_image`"}
                                {if !empty($image.legend)}
                                    {assign var=imageTitle value=$image.legend}
                                {else}
                                    {assign var=imageTitle value=$productAMP.name}
                                {/if}
                                <amp-img
                                        src="{$link->getImageLink($productAMP.link_rewrite, $imageIds, 'large_default')}"
                                        width="{$largeSize['width']}"
                                        height="{$largeSize['height']}"
                                        layout="responsive"
                                        alt="{$imageTitle}">
                                </amp-img>
                            {/foreach}
                        {/if}
                    </amp-carousel>
                </div>
                <h1 id="product-name-amp">
                    {$productAMP.name}
                </h1>
                <span id="amp-reference">{l s='Reference' mod='cbamp'}: {$productAMP.reference}</span>
                <p>
                    {$productAMP.clean_description nofilter}
                </p>

                <!-- combinations -->
                {if (!empty($productAMP.combinations))}
                        <h2>{l s='Options' mod='amp'}</h2>
                        <select on="change:AMP.navigateTo(url=event.value)">
                        {foreach from=$productAMP.combinations item=comb}
                            <option data-id="{$comb.id_product}-{$comb.id_product_attribute}" value="{$comb.goLink}" {if $idpipa == "{$comb.id_product}-{$comb.id_product_attribute}"} selected {/if}>{$comb.attribute_designation}</option>
                        {/foreach}
                        </select>
					</div>
                {/if}
                <!--combinations -->

                <!-- Data sheet -->
                {if (!empty($productAMP.features))}
					<div id="amp-datasheet">
                        <h2>{l s='Features' mod='amp'}</h2>
						<dl class="table-data-sheet">
							{foreach from=$productAMP.features item=feature}
								{if isset($feature.value)}
							    	<dt>{$feature.name|escape:'html':'UTF-8'}</dt>
								    <dd>{$feature.value|escape:'html':'UTF-8'}</dd>
								{/if}
							{/foreach}
						</dl>
					</div>
                {/if}
                <!--end Data sheet -->
                
                <p>
                    <span id="product-price-amp">
                        {$productAMP.price}
                    </span>
                    <span id="product-price-old-amp">
                        {$productAMP.price_old}
                    </span>
                </p>
                {if !$configuration.is_catalog}
                    <p id="product-add-to-cart-amp">
                        <a href="{$addToCartLink}" class="btn btn-primary">
                            {l s='Add to cart' mod='cbamp'}
                        </a>
                    </p>
                {/if}
            </div>
            <div class="amp-social">
                <amp-social-share type="twitter"
                    width="30"
                    height="22"></amp-social-share>
                <amp-social-share type="facebook"
                    width="30"
                    height="22"
                    data-attribution="254325784911610"></amp-social-share>
                <amp-social-share type="email"
                    width="30"
                    height="22"></amp-social-share>
                <amp-social-share type="pinterest"
                    width="33"
                    height="22"></amp-social-share>
            </div>
            <div id="full-version-link">
			    <a href="{$canonical}" title="{l s='See full version' mod='cbamp'}">{l s='See full version' mod='cbamp'}</a>
		    </div>
            <footer>
                &copy;  {$shop.name} - {date('Y')}
            </footer>
        </div>
    </body>
</html>