public function requestOtp(Request $request) {
$request->validate(['mobile' => 'required|regex:/^09[0-9]{9}$/']);

// Rate Limiting
if (RateLimiter::tooManyAttempts('otp-'.$request->ip(), 3)) {
return response()->json(['error' => 'Too many attempts!'], 429);
}

$otp = rand(100000, 999999);
$smsService = new SmsService();

if ($smsService->sendOTP($request->mobile, $otp)) {
User::updateOrCreate(
['mobile' => $request->mobile],
['sms_token' => Hash::make($otp), 'sms_sent_at' => now()]
);
RateLimiter::hit('otp-'.$request->ip(), 300); // 5 دقیقه محدودیت
return response()->json(['status' => 'success']);
}

return response()->json(['error' => 'SMS failed!'], 500);
}