<?php

namespace App\Http\Controllers;

abstract class Controller
{
    // در کنترلر محصولات
    public function index()
    {
        return Cache::remember('all_products', 3600, function () {
            return Product::with('category')
                ->active()
                ->orderBy('stock_count', 'desc')
                ->paginate(25);
        });
    }
}
