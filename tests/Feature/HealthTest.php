<?php

use function Pest\Laravel\get;

it('reports the application as up', function () {
    get('/up')->assertOk();
});
