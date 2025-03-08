<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Casts\Attribute;

class Product extends Model
{
       protected $casts = [
              'price' => 'decimal:2',
              'special_price' => 'decimal:2',
              'stock_count' => 'integer',
       ];

       protected $appends = ['final_price'];

       protected function finalPrice(): Attribute
       {
              return Attribute::make(
                     get: fn() => $this->special_price ?? $this->price
              );
       }

       public function scopeActive($query)
       {
              return $query->where('status', 'active');
       }

       public function category()
       {
              return $this->belongsTo(Category::class);
       }
}
