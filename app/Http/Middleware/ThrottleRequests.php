protected function resolveRequestSignature($request)
{
return sha1(
$request->method() .
'|' . $request->server('SERVER_NAME') .
'|' . $request->ip()
);
}