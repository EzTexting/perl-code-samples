#!/usr/bin/perl
use LWP::UserAgent;
use HTTP::Request::Common qw(POST);
use XML::Simple;

$ua = new LWP::UserAgent(keep_alive=>1);

$params = "";
$params.= "User=winnie&Password=the-pooh";
$params.= "&NumberOfCredits=1000";
$params.= "&CouponCode=honey2011";
$params.= "&FirstName=Winnie";
$params.= "&LastName=The Pooh";
$params.= "&Street=Hollow tree, under the name of Mr. Sanders";
$params.= "&City=Hundred Acre Woods";
$params.= "&State=New York";
$params.= "&Zip=12345";
$params.= "&Country=US";
$params.= "&CreditCardTypeID=Visa";
$params.= "&Number=4111111111111111";
$params.= "&SecurityCode=123";
$params.= "&ExpirationMonth=10";
$params.= "&ExpirationYear=2017";


my $responde = HTTP::Request->new(POST => "https://app.eztexting.com/billing/credits?format=xml");
$responde->content_type("application/x-www-form-urlencoded");
$responde->content($params);

$responseObj = $ua->request($responde);

print $responseObj->content."\n--------------------\n";

$responseCode = $responseObj->code;
print 'Response code: ' . $responseCode . "\n";
$isSuccesResponse = $responseCode < 400;

$response = XML::Simple->new->XMLin($responseObj->content);

print 'Status: ' . $response->{Status} . "\n" .
      'Code: ' . $response->{Code} . "\n";
if ($isSuccesResponse) {
    print 'Credits purchased: ' . $response->{Entry}->{BoughtCredits} . "\n" .
          'Amount charged, $: ' . $response->{Entry}->{Amount} . "\n" .
          'Discount, $: ' . $response->{Entry}->{Discount} . "\n" .
          'Plan credits: ' . $response->{Entry}->{PlanCredits} . "\n" .
          'Anytime credits: ' . $response->{Entry}->{AnytimeCredits} . "\n" .
          'Total: ' . $response->{Entry}->{TotalCredits} . "\n";
} else {
    $errors = $response->{Errors}->{Error};
    print 'Errors: ' .(ref($errors) eq 'ARRAY' ? join(', ', @{$errors}) : $errors) . "\n";
}


                    