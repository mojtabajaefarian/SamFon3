<?php

namespace App\Jobs;

use App\Models\Product;
use Automattic\WooCommerce\Client;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Bus\Dispatchable;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Queue\SerializesModels;

class SyncProductWithWooCommerce implements ShouldQueue
{
       use Dispatchable, InteractsWithQueue, Queueable, SerializesModels;

       public function __construct(public Product $product) {}

       public function handle()
       {
              $wc = new Client(
                     config('woocommerce.url'),
                     config('woocommerce.key'),
                     config('woocommerce.secret'),
                     ['timeout' => 60]
              );

              try {
                     $data = [
                            'name' => $this->product->title,
                            'sku' => 'SF-' . $this->product->id,
                            'regular_price' => (string)$this->product->price,
                            'stock_quantity' => $this->product->stock_count,
                            'images' => [['src' => $this->product->image_url]]
                     ];

                     if ($this->product->woocommerce_id) {
                            $wc->put("products/{$this->product->woocommerce_id}", $data);
                     } else {
                            $response = $wc->post('products', $data);
                            $this->product->woocommerce_id = $response->id;
                            $this->product->save();
                     }
              } catch (\Exception $e) {
                     Log::error('WooCommerce Sync Error: ' . $e->getMessage());
                     $this->release(60); // 1 دقیقه بعد دوباره امتحان کند
              }
       }
}
