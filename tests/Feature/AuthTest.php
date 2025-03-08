<?php

namespace Tests\Feature;

use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class AuthTest extends TestCase
{
    use RefreshDatabase;

    public function test_sms_otp_flow() {
        // تست درخواست OTP
        $response = $this->postJson('/api/auth/request-otp', [
            'mobile' => '09123456789'
        ]);
        $response->assertStatus(200);
        
        // تست احراز هویت
        $user = User::first();
        $response = $this->postJson('/api/auth/verify-otp', [
            'mobile' => '09123456789',
            'otp' => '123456' // باید با Hash تطابق داده شود
        ]);
        $response->assertStatus(401);
    }
}