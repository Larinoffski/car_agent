<?php

use Illuminate\Support\Facades\DB;

it('runs in the testing environment', function () {
    expect(app()->environment())->toBe('testing');
});

it('connects to the PostgreSQL test database', function () {
    expect(config('database.default'))->toBe('pgsql')
        ->and(DB::connection()->getDatabaseName())->toBe('car_agent_test');
});
