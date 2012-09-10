#!/usr/bin/perl
use LWP::UserAgent;
use HTTP::Request::Common qw(POST);
use JSON::XS;

$ua = new LWP::UserAgent(keep_alive=>1);

$params = "";
$params.= "User=winnie&Password=the-pooh";

my $responde = HTTP::Request->new(POST => "https://app.eztexting.com/keywords/honey?format=json&_method=DELETE");
$responde->content_type("application/x-www-form-urlencoded");
$responde->content($params);

$responseObj = $ua->request($responde);

print $responseObj->content."\n--------------------\n";


$responseCode = $responseObj->code;
print 'Response code: ' . $responseCode . "\n";
$isSuccesResponse = $responseCode < 400;

if (!$isSuccesResponse) {
    $response = JSON::XS->new->decode ($responseObj->content);
    print 'Status: ' . $response->{Response}->{Status} . "\n" .
          'Code: ' . $response->{Response}->{Code} . "\n";
    foreach $err (@{$response->{Response}->{Errors}}) {
        print 'Error: ' . $err . "\n";
    }
}


