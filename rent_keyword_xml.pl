#!/usr/bin/perl
use LWP::UserAgent;
use HTTP::Request::Common qw(POST);
use XML::Simple;

$ua = new LWP::UserAgent(keep_alive=>1);

$params = "";
$params.= "User=demo&Password=texting121212";
$params.= "&Subject=From Winnie";
$params.= "&Keyword=honey";
$params.= "&StoredCreditCard=1111";


my $responde = HTTP::Request->new(POST => "https://app.eztexting.com/keywords?format=xml");
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
    $groups = $response->{Entry}->{ContactGroupIDs}->{Group};
    print 'Keyword ID: ' . $response->{Entry}->{ID} . "\n".
          'Keyword: ' . $response->{Entry}->{Keyword} . "\n" .
          'Is double opt-in enabled: ' .  $response->{Entry}->{EnableDoubleOptIn} . "\n" .
          'Confirm message: ' . $response->{Entry}->{ConfirmMessage} . "\n" .
          'Join message: ' . $response->{Entry}->{JoinMessage} . "\n" .
          'Forward email: ' . $response->{Entry}->{ForwardEmail} . "\n" .
          'Forward url: ' . $response->{Entry}->{ForwardUrl} . "\n" .
          'Groups: ' . (ref($groups) eq 'ARRAY' ? join(', ', @{$groups}) : $groups)."\n";
} else {
    $errors = $response->{Errors}->{Error};
    print 'Errors: ' .(ref($errors) eq 'ARRAY' ? join(', ', @{$errors}) : $errors) . "\n";
}

                    