#!/usr/bin/perl
use LWP::UserAgent;
use HTTP::Request::Common qw(POST);
use JSON::XS;

$ua = new LWP::UserAgent(keep_alive=>1);

$params = "";
$params.= "User=winnie&Password=the-pooh";

my $responde = HTTP::Request->new(GET => "https://app.eztexting.com/billing/credits/get?format=json&".$params);

$responseObj = $ua->request($responde);

print $responseObj->content."\n--------------------\n";

$responseCode = $responseObj->code;
print 'Response code: ' . $responseCode . "\n";
$isSuccesResponse = $responseCode < 400;

$response = JSON::XS->new->decode ($responseObj->content);

print 'Status: ' . $response->{Response}->{Status} . "\n" .
      'Code: ' . $response->{Response}->{Code} . "\n";
if ($isSuccesResponse) {
    print 'Plan credits: ' . $response->{Response}->{Entry}->{PlanCredits} . "\n" .
          'Anytime credits: ' . $response->{Response}->{Entry}->{AnytimeCredits} . "\n" .
          'Total: ' . $response->{Response}->{Entry}->{TotalCredits} . "\n";
} else {
    foreach $err (@{$response->{Response}->{Errors}}) {
        print 'Error: ' . $err . "\n";
    }
}

