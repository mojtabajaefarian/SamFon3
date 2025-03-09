<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

// app/Models/Simcard.php
class Simcard extends Model
{
    protected $fillable = [
        'number',
        'operator',
        'type',
        'current_balance',
        'activation_date',
        'expiry_date',
        'status'
    ];

    public function transactions()
    {
        return $this->hasMany(Transaction::class);
    }
}

// app/Models/Transaction.php
class Transaction extends Model
{
    protected $fillable = [
        'simcard_id',
        'user_id',
        'amount',
        'type',
        'description'
    ];

    public function simcard()
    {
        return $this->belongsTo(Simcard::class);
    }

    public function user()
    {
        return $this->belongsTo(User::class);
    }
}
