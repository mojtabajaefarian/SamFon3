<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\User;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Str;
use Twilio\Rest\Client;
use Illuminate\Support\Facades\RateLimiter;

class AuthController extends Controller
{
       // در AuthController.php
       private function sendSmsOTP($mobile)
       {
              $otp = Str::random(6);

              $sms = resolve(\Melipayamak\MelipayamakService::class);
              $sms->send(
                     $mobile,
                     "کد ورود شما: $otp"
              );

              return $otp;
       }

       public function requestOTP(Request $request)
       {
              $request->validate(['mobile' => 'required|regex:/^09[0-9]{9}$/']);

              RateLimiter::hit('otp-' . $request->ip(), 60);

              $user = User::firstOrNew(['mobile' => $request->mobile]);
              $user->sms_token = $this->sendSmsOTP($request->mobile);
              $user->save();

              return response()->json(['message' => 'کد ارسال شد']);
       }

       public function verifyOTP(Request $request)
       {
              $request->validate([
                     'mobile' => 'required',
                     'otp' => 'required|digits:6'
              ]);

              $user = User::where('mobile', $request->mobile)
                     ->where('sms_token', $request->otp)
                     ->firstOrFail();

              $user->update([
                     'sms_token' => null,
                     'last_login' => now()
              ]);

              return response()->json([
                     'token' => $user->createToken('SamFonAuth')->plainTextToken
              ]);
       }
}
