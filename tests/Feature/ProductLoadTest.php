<?php

namespace Tests\Feature;

use Tests\TestCase;
use App\Models\Product;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\DB;

class ProductLoadTest extends TestCase
{
       use RefreshDatabase;

       public function test_product_index_load_time()
       {
              // ساخت داده‌ها با Bulk Insert
              Product::insert(
                     Product::factory()->count(30000)->make()->toArray()
              );

              $start = microtime(true);
              $response = $this->get('/api/v1/products');
              $end = microtime(true);

              $response->assertStatus(200);
              $this->assertLessThan(1.5, $end - $start);

              $products = Product::factory(30000)->make()->toArray();
              DB::table('products')->insert($products);

              $start = microtime(true);
              $response = $this->get('/api/v1/products');
              $end = microtime(true);

              $response->assertStatus(200);
              $this->assertLessThan(1.5, $end - $start);
       }
}
