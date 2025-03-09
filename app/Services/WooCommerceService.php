<?php

use Automattic\WooCommerce\Client;

class WooCommerceService
{
       public function syncProducts()
       {
              $woocommerce = new Client(
                     config('woocommerce.store_url'),
                     config('woocommerce.consumer_key'),
                     config('woocommerce.consumer_secret'),
                     ['version' => 'wc/v3']
              );

              // Sync logic here
       }
}
