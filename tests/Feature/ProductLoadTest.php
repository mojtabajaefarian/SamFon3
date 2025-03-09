
<?php

namespace Tests\Feature;

use Tests\TestCase;
use App\Models\Product;
use Illuminate\Foundation\Testing\RefreshDatabase;

class ProductLoadTest extends TestCase
{
       use RefreshDatabase;

       public function test_product_index_load_time()
       {
              Product::factory()->count(30000)->create();

              $start = microtime(true);
              $response = $this->get('/api/v1/products');
              $end = microtime(true);

              $response->assertStatus(200);
              $this->assertLessThan(1.5, $end - $start);
       }
}
