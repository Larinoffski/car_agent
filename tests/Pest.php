<?php

use Tests\TestCase;

// Feature tests boot the Laravel application; Unit tests stay plain PHPUnit test cases.
pest()->extend(TestCase::class)->in('Feature');
