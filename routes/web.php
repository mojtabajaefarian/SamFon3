<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\HomeController;
use App\Http\Controllers\ProductController;
use App\Http\Controllers\OrderController;
use App\Models\Product;

// ------ روت اصلی ------
Route::get('/', [HomeController::class, 'index'])->name('home');

// ------ احراز هویت ------
Auth::routes();

// ------ تست عملکرد ------
Route::get('/stress-test', function () {
    $start = microtime(true);
    $products = Product::with('category')->paginate(100);
    $end = microtime(true);
    return "زمان اجرا: " . ($end - $start) . " ثانیه";
})->middleware('auth');

// ------ مدیریت محصولات ------
Route::resource('products', ProductController::class)
    ->middleware('can:manage-products');

// ------ رهگیری سفارش ------
Route::get('/track-order/{tracking_code}', [OrderController::class, 'track'])
    ->name('orders.track');
