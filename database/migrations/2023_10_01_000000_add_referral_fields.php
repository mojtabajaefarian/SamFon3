<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class AddReferralFields extends Migration
{
       public function up()
       {
              Schema::table('users', function (Blueprint $table) {
                     $table->string('referral_code', 8)->unique()->nullable();
                     $table->unsignedBigInteger('referred_by')->nullable();
                     $table->decimal('referral_balance', 12, 2)->default(0);
              });
       }
}
