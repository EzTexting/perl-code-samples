#!/usr/bin/perl
use LWP::UserAgent;
use HTTP::Request::Common qw(POST);
use JSON::XS;

$ua = new LWP::UserAgent(keep_alive=>1);

$params = "";
$params.= "User=winnie&Password=the-pooh";
$params.= "&Subject=From Winnie";
$params.= "&Message=I am a Bear of Very Little Brain, and long words bother me";
$params.= "&PhoneNumbers[]=2123456785&PhoneNumbers[]=2123456786";
$params.= "&MessageTypeID=1&StampToSend=1305582245";

my $responde = HTTP::Request->new(POST => "https://app.eztexting.com/sending/messages?format=json");
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
    print 'Message ID: ' . $response->{Response}->{Entry}->{ID} . "\n".
          'Subject: ' . $response->{Response}->{Entry}->{Subject} . "\n" .
          'Message: ' . $response->{Response}->{Entry}->{Message} . "\n" .
          'Message Type ID: ' . $response->{Response}->{Entry}->{MessageTypeID} . "\n" .
          'Total Recipients: ' . $response->{Response}->{Entry}->{RecipientsCount} . "\n" .
          'Credits Charged: ' . $response->{Response}->{Entry}->{Credits} . "\n" .
          'Time To Send: ' . $response->{Response}->{Entry}->{StampToSend} . "\n".
          'Phone Numbers: ' . join(', ', @{$response->{Response}->{Entry}->{PhoneNumbers}}) . "\n" .
          'Locally Opted Out Numbers: ' . join(', ', @{$response->{Response}->{Entry}->{LocalOptOuts}}) . "\n" .
          'Globally Opted Out Numbers: ' . join(', ', @{$response->{Response}->{Entry}->{GlobalOptOuts}}) . "\n";
} else {
    foreach $err (@{$response->{Response}->{Errors}}) {
        print 'Error: ' . $err . "\n";
    }
}

              