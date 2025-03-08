<?php

namespace App\Services;

use Melipayamak\MelipayamakService;
use Illuminate\Support\Facades\Log;

class SmsService
{
       public function sendOTP($mobile, $otp)
       {
              try {
                     $sms = resolve(MelipayamakService::class);
                     $sms->send(
                            $mobile,
                            "کد ورود SamFon: \n $otp"
                     );
                     return true;
              } catch (\Exception $e) {
                     Log::error('SMS Error: ' . $e->getMessage());
                     return false;
              }
       }
}
