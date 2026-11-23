<?php

use Illuminate\Foundation\Application;
use Illuminate\Foundation\Configuration\Exceptions;
use Illuminate\Foundation\Configuration\Middleware;

return Application::configure(basePath: dirname(__DIR__))
    ->withRouting(
        web: __DIR__.'/../routes/web.php',
        commands: __DIR__.'/../routes/console.php',
        health: '/up',
    )
    ->withMiddleware(function (Middleware $middleware): void {
        //
    })
    ->withExceptions(function (Exceptions $exceptions): void {
        //
    })->create()
    // Configuration comes from the container environment; there is no dotenv file (ADR 0004).
    // Pointing the loader at an empty file avoids a failed read on every start.
    ->useEnvironmentPath('/dev')
    ->loadEnvironmentFrom('null');
