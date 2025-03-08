@extends('layouts.app')

@section('content')
<div class="container">
       <div class="row justify-content-center">
              @foreach($products as $product)
              <div class="col-md-4 mb-4">
                     <div class="card rtl" style="direction: rtl;">
                            <img src="{{ $product->image_url }}" class="card-img-top" alt="{{ $product->title }}">
                            <div class="card-body">
                                   <h5 class="card-title">{{ $product->title }}</h5>
                                   <p class="text-muted">{{ number_format($product->price) }} تومان</p>
                                   <a href="{{ route('products.buy', $product) }}" class="btn btn-primary">
                                          خرید از ووکامرس
                                   </a>
                            </div>
                     </div>
              </div>
              @endforeach
       </div>
       {{ $products->links() }}
</div>
@endsection