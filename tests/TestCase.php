<?php

namespace Tests;

use Illuminate\Foundation\Testing\TestCase as BaseTestCase;
use RuntimeException;

abstract class TestCase extends BaseTestCase
{
    private static ?string $appKey = null;

    protected function refreshApplication(): void
    {
        parent::refreshApplication();

        $this->guardTestDatabase();

        // A throwaway key per run: tests never use a real one and CI needs none.
        self::$appKey ??= 'base64:'.base64_encode(random_bytes(32));
        config(['app.key' => self::$appKey]);
    }

    /**
     * Stops the run before any test can touch a non-test database,
     * e.g. when the overrides in phpunit.xml did not apply.
     */
    private function guardTestDatabase(): void
    {
        $connection = (array) config('database.connections.'.config('database.default'));
        $database = (string) ($connection['database'] ?? '');

        if (! str_ends_with($database, '_test')) {
            throw new RuntimeException("Tests must run against a *_test database, got [{$database}].");
        }

        // A connection URL overrides the database name at connect time, behind the check above.
        if (! empty($connection['url'])) {
            throw new RuntimeException('Tests must not use a database URL (DB_URL): it overrides the database name.');
        }
    }
}
