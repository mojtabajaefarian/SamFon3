<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

// app/Models/Order.php
class Order extends Model
{
       public function items()
       {
              return $this->hasMany(OrderItem::class);
       }
}
