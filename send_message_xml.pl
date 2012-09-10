#!/usr/bin/perl
use LWP::UserAgent;
use HTTP::Request::Common qw(POST);
use XML::Simple;

$ua = new LWP::UserAgent(keep_alive=>1);

$params = "";
$params.= "User=winnie&Password=the-pooh";
$params.= "&Subject=From Winnie";
$params.= "&Message=I am a Bear of Very Little Brain, and long words bother me";
$params.= "&PhoneNumbers[]=2123456785&PhoneNumbers[]=2123456786";
$params.= "&MessageTypeID=1&StampToSend=1305582245";

my $responde = HTTP::Request->new(POST => "https://app.eztexting.com/sending/messages?format=xml");
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
    $PhoneNumbers = $response->{Entry}->{PhoneNumbers}->{PhoneNumber};
    $LocalOptOuts = $response->{Entry}->{LocalOptOuts}->{PhoneNumber};
    $GlobalOptOuts = $response->{Entry}->{GlobalOptOuts}->{PhoneNumber};
    print 'Message ID: ' . $response->{Entry}->{ID} . "\n" .
          'Subject: ' . $response->{Entry}->{Subject} . "\n" .
          'Message: ' . $response->{Entry}->{Message} . "\n" .
          'Message Type ID: ' . $response->{Entry}->{MessageTypeID} . "\n" .
          'Total Recipients: ' . $response->{Entry}->{RecipientsCount} . "\n" .
          'Credits Charged: ' . $response->{Entry}->{Credits} . "\n" .
          'Time To Send: ' . $response->{Entry}->{StampToSend} . "\n".
          'Phone Numbers: ' . (ref($PhoneNumbers) eq 'ARRAY' ? join(', ', @{$PhoneNumbers}) : $PhoneNumbers) . "\n" .
          'Locally Opted Out Numbers: ' . (ref($LocalOptOuts) eq 'ARRAY' ? join(', ', @{$LocalOptOuts}) : $LocalOptOuts) . "\n" .
          'Globally Opted Out Numbers: ' . (ref($GlobalOptOuts) eq 'ARRAY' ? join(', ', @{$GlobalOptOuts}) : $GlobalOptOuts) . "\n";
} else {
    $errors = $response->{Errors}->{Error};
    print 'Errors: ' .(ref($errors) eq 'ARRAY' ? join(', ', @{$errors}) : $errors) . "\n";
}

              