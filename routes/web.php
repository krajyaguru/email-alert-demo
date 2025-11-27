<?php

use Illuminate\Support\Facades\Route;
use App\Services\SnsService;

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| contains the "web" middleware group. Now create something great!
|
*/

Route::get('/send-demo-alert', function (SnsService $sns) {
    $sns->publish([
        'email'   => 'your@email.com',
        'subject' => 'Demo Alert Email',
        'message' => 'This email flowed through SNS → Lambda → SQS → Laravel!',
        'extra'   => ['time' => now()]
    ]);

    return "Alert sent to SNS!";
});

