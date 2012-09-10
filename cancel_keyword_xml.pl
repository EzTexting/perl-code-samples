#!/usr/bin/perl
use LWP::UserAgent;
use HTTP::Request::Common qw(POST);
use XML::Simple;

$ua = new LWP::UserAgent(keep_alive=>1);

$params = "";
$params.= "User=winnie&Password=the-pooh";

my $responde = HTTP::Request->new(POST => "https://app.eztexting.com/keywords/honey?format=xml&_method=DELETE");
$responde->content_type("application/x-www-form-urlencoded");
$responde->content($params);

$responseObj = $ua->request($responde);

print $responseObj->content."\n--------------------\n";

$responseCode = $responseObj->code;
print 'Response code: ' . $responseCode . "\n";
$isSuccesResponse = $responseCode < 400;


if (!$isSuccesResponse) {
    $response = XML::Simple->new->XMLin($responseObj->content);
    print 'Status: ' . $response->{Status} . "\n" .
          'Code: ' . $response->{Code} . "\n";
    $errors = $response->{Errors}->{Error};
    print 'Errors: ' .(ref($errors) eq 'ARRAY' ? join(', ', @{$errors}) : $errors) . "\n";
}


