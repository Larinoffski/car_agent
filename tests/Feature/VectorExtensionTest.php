<?php

use Illuminate\Support\Facades\DB;

it('has the vector extension in the test database', function () {
    $installed = DB::table('pg_extension')->where('extname', 'vector')->exists();

    expect($installed)->toBeTrue();
});
