<header class="bg-gradient-to-r from-blue-500 to-indigo-500 text-white shadow-md">
       <nav class="container mx-auto px-4 py-4 flex justify-between items-center">
              <a href="{{ route('home') }}" class="flex items-center gap-2">
                     <x-application-logo class="h-8 w-auto" />
                     <span class="text-xl font-bold">{{ config('app.name') }}</span>
              </a>

              <div class="hidden md:flex space-x-6">
                     @foreach($navigationLinks as $link)
                     <a href="{{ $link['url'] }}" class="hover:text-blue-200 transition-colors">
                            <i class="{{ $link['icon'] }} mr-1"></i>
                            {{ $link['text'] }}
                     </a>
                     @endforeach
              </div>
       </nav>
</header>