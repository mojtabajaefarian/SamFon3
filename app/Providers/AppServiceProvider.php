<?php

namespace App\Providers;

use Illuminate\Support\Facades\Gate;
use Illuminate\Support\ServiceProvider;
use Illuminate\Support\Facades\Request;
use App\Http\Middleware\SanitizeInput; // اطمینان حاصل کنید Namespace صحیح است

class AppServiceProvider extends ServiceProvider
{
    /**
     * Register any application services.
     */
    public function register(): void
    {
        //
    }

    /**
     * Bootstrap any application services.
     */
    public function boot(): void // اضافه کردن نوع بازگشتی void
    {
        // فعال سازی Middleware جهانی
        Request::macro('sanitize', function () {
            return $this->merge((new SanitizeInput())->handle($this, function ($req) {
                return $req;
            })->all());
        });

        // تعیین دسترسی manage-products
        Gate::define('manage-products', function ($user) {
            return $user->is_admin;
        });
    }
}
