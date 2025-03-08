<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Product;
use Automattic\WooCommerce\Client;

class WooCommerceController extends Controller
{
       private function wooCommerceClient()
       {
              return new Client(
                     config('services.woocommerce.url'),
                     config('services.woocommerce.key'),
                     config('services.woocommerce.secret'),
                     [
                            'version' => 'wc/v3',
                            'timeout' => 30
                     ]
              );
       }

       public function syncProduct(Product $product)
       {
              $woocommerce = $this->wooCommerceClient();

              $data = [
                     'name' => $product->title,
                     'type' => 'simple',
                     'regular_price' => (string)$product->price,
                     'description' => $product->description,
                     'short_description' => Str::limit($product->description, 160),
                     'sku' => 'SF-' . $product->id,
                     'manage_stock' => true,
                     'stock_quantity' => $product->stock_count,
                     'images' => [
                            ['src' => $product->image_url]
                     ]
              ];

              try {
                     $response = $woocommerce->post('products', $data);
              } catch (\Exception $e) {
                     // Log error and retry mechanism
              }
       }

       public function createOrder(Request $request)
       {
              $woocommerce = $this->wooCommerceClient();

              $orderData = [
                     'payment_method' => 'bacs',
                     'payment_method_title' => 'Direct Bank Transfer',
                     'status' => 'pending',
                     'customer_id' => auth()->id(),
                     'line_items' => [
                            [
                                   'product_id' => $request->product_id,
                                   'quantity' => 1
                            ]
                     ]
              ];

              $response = $woocommerce->post('orders', $orderData);

              // Update local order status
              Order::create([
                     'user_id' => auth()->id(),
                     'woocommerce_order_id' => $response->id,
                     'status' => 'pending',
                     'total_price' => $response->total
              ]);

              return response()->json([
                     'redirect_url' => $response->payment_url
              ]);
       }
}
