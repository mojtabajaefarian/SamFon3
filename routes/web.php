<?php

use Illuminate\Support\Facades\Route;

Route::get('/', function () {
    return view('welcome');
});

// در routes/web.php
Route::get('/stress-test', function () {
    $start = microtime(true);
    $products = Product::with('category')->paginate(100);
    $end = microtime(true);

    return "زمان اجرا: " . ($end - $start) . " ثانیه";
});
