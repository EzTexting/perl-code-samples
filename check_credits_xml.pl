#!/usr/bin/perl
use LWP::UserAgent;
use HTTP::Request::Common qw(POST);
use XML::Simple;

$ua = new LWP::UserAgent(keep_alive=>1);

$params = "";
$params.= "User=winnie&Password=the-pooh";

my $responde = HTTP::Request->new(GET => "https://app.eztexting.com/billing/credits/get?format=xml&".$params);

$responseObj = $ua->request($responde);

print $responseObj->content."\n--------------------\n";

$responseCode = $responseObj->code;
print 'Response code: ' . $responseCode . "\n";
$isSuccesResponse = $responseCode < 400;

$response = XML::Simple->new->XMLin($responseObj->content);

print 'Status: ' . $response->{Status} . "\n" .
      'Code: ' . $response->{Code} . "\n";
if ($isSuccesResponse) {
    print 'Plan credits: ' . $response->{Entry}->{PlanCredits} . "\n" .
          'Anytime credits: ' . $response->{Entry}->{AnytimeCredits} . "\n" .
          'Total: ' . $response->{Entry}->{TotalCredits} . "\n";
} else {
    $errors = $response->{Errors}->{Error};
    print 'Errors: ' .(ref($errors) eq 'ARRAY' ? join(', ', @{$errors}) : $errors) . "\n";
}

