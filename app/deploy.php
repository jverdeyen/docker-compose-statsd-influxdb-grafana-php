<?php

/**
 * Simulate a deploy trigger
 */

require __DIR__.'/vendor/autoload.php';

$connection = new \Domnikl\Statsd\Connection\UdpSocket('statsd', 8125);

$statsd = new \Domnikl\Statsd\Client($connection, "app.demo.events");

$statsd->increment("deploy");

echo "Deploy triggered.";
