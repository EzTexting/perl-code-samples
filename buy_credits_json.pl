#!/usr/bin/perl
use LWP::UserAgent;
use HTTP::Request::Common qw(POST);
use JSON::XS;

$ua = new LWP::UserAgent(keep_alive=>1);

$params = "";
$params.= "User=demo&Password=texting121212";
$params.= "&NumberOfCredits=1000";
$params.= "&CouponCode=honey2011";
$params.= "&StoredCreditCard=1111";


my $responde = HTTP::Request->new(POST => "https://app.eztexting.com/billing/credits?format=json");
$responde->content_type("application/x-www-form-urlencoded");
$responde->content($params);

$responseObj = $ua->request($responde);

print $responseObj->content."\n--------------------\n";

$responseCode = $responseObj->code;
print 'Response code: ' . $responseCode . "\n";
$isSuccesResponse = $responseCode < 400;

$response = JSON::XS->new->decode ($responseObj->content);

print 'Status: ' . $response->{Response}->{Status} . "\n" .
      'Code: ' . $response->{Response}->{Code} . "\n";
if ($isSuccesResponse) {
    print 'Credits purchased: ' . $response->{Response}->{Entry}->{BoughtCredits} . "\n" .
          'Amount charged, $: ' . $response->{Response}->{Entry}->{Amount} . "\n" .
          'Discount, $: ' . $response->{Response}->{Entry}->{Discount} . "\n" .
          'Plan credits: ' . $response->{Response}->{Entry}->{PlanCredits} . "\n" .
          'Anytime credits: ' . $response->{Response}->{Entry}->{AnytimeCredits} . "\n" .
          'Total: ' . $response->{Response}->{Entry}->{TotalCredits} . "\n";
} else {
    foreach $err (@{$response->{Response}->{Errors}}) {
        print 'Error: ' . $err . "\n";
    }
}



