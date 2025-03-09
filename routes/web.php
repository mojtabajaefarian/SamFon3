<?php

use Illuminate\Support\Facades\Route;
use App\Models\Product; // اضافه کردن ایمپورت مدل Product
use Illuminate\Support\Facades\Auth;
use App\Http\Controllers\ProductController;
use app\Models\Order;

Route::get('/', function () {
    return view('welcome');
});

// تست استرس
Route::get('/stress-test', function () {
    $start = microtime(true);
    $products = Product::with('category')->paginate(100);
    $end = microtime(true);

    return "زمان اجرا: " . ($end - $start) . " ثانیه";
});

Auth::routes();

// حذف خطوط تکراری
// Auth::routes(); // ❌ حذف شد
// Route::get('/home', ...); // ❌ حذف شد

Route::get('/home', [App\Http\Controllers\HomeController::class, 'index'])->name('home');

Route::resource('products', ProductController::class)->middleware('can:manage-products');

Route::get('/track-order/{tracking_code}', [OrderController::class, 'track']);