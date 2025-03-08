<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

Route::prefix('v1')->group(function () {
       // Authentication
       Route::post('/auth/request-otp', [AuthController::class, 'requestOTP']);
       Route::post('/auth/verify-otp', [AuthController::class, 'verifyOTP']);

       // Products
       Route::get('/products', [ProductController::class, 'index']);
       Route::get('/products/{id}', [ProductController::class, 'show']);

       // Orders
       Route::middleware('auth:sanctum')->group(function () {
              Route::post('/orders', [OrderController::class, 'store']);
              Route::get('/orders/{id}', [OrderController::class, 'show']);
       });

       // Admin Endpoints
       Route::prefix('admin')->middleware(['auth:sanctum', 'admin'])->group(function () {
              Route::get('/reports', [ReportController::class, 'index']);
              Route::get('/low-stock', [ReportController::class, 'lowStock']);
       });
});
