public function handleOrderUpdate(Request $request)
{
$validated = $request->validate([
'id' => 'required|integer',
'status' => 'required|string'
]);

$order = Order::where('woocommerce_order_id', $validated['id'])->first();

if($order) {
$order->update(['status' => $validated['status']]);

// Send notification
event(new OrderStatusUpdated($order));
}

return response()->json(['status' => 'success']);
}