<?php

namespace App\Providers;

use Illuminate\Support\ServiceProvider;

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
    public function boot()
    {
        // فعال سازی Middleware جهانی
        \Illuminate\Support\Facades\Request::macro('sanitize', function () {
            return $this->merge((new SanitizeInput())->handle($this, function ($req) {
                return $req;
            })->all());
        });
    }
}
