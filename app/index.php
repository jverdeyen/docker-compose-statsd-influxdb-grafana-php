<?php

/**
 * Simulate a page load
 */

require __DIR__.'/vendor/autoload.php';

$connection = new \Domnikl\Statsd\Connection\UdpSocket('statsd', 8125);

$statsd = new \Domnikl\Statsd\Client($connection, "app.demo");

$statsd->startTiming("loadtime");

$time = rand(1000, 10000000);
$sleep = usleep($time);

$statsd->endTiming("loadtime");

echo $time;
