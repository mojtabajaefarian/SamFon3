<?php

return [
       'url' => env('WOOCONNECT_URL'),
       'key' => env('WOOCONSUMER_KEY'),
       'secret' => env('WOOCONSUMER_SECRET'),

       'webhooks' => [
              'order_updated' => env('APP_URL') . '/api/webhooks/order-updated'
       ],

       'retry' => [
              'attempts' => 3,
              'delay' => 60 // ثانیه
       ]
];
