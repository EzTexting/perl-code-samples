#!/usr/bin/perl
use LWP::UserAgent;
use HTTP::Request::Common qw(POST);
use JSON::XS;

$ua = new LWP::UserAgent(keep_alive=>1);

$params = "";
$params.= "User=winnie&Password=the-pooh";
$params.= "&EnableDoubleOptIn=1";
$params.= "&ConfirmMessage=Reply Y to join our sweetest list";
$params.= "&JoinMessage=The only reason for being a bee that I know of, is to make honey. And the only reason for making honey, is so as I can eat it.";
$params.= '&ForwardEmail=honey@bear-alliance.co.uk';
$params.= "&ForwardUrl=http://bear-alliance.co.uk/honey-donations/";
$params.= "&ContactGroupIDs[]=honey";
$params.= "&ContactGroupIDs[]=lovers";

my $responde = HTTP::Request->new(POST => "https://app.eztexting.com/keywords/honey?format=json");
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
    print 'Keyword ID: ' . $response->{Response}->{Entry}->{ID} . "\n".
          'Keyword: ' . $response->{Response}->{Entry}->{Keyword} . "\n" .
          'Is double opt-in enabled: ' .  $response->{Response}->{Entry}->{EnableDoubleOptIn} . "\n" .
          'Confirm message: ' . $response->{Response}->{Entry}->{ConfirmMessage} . "\n" .
          'Join message: ' . $response->{Response}->{Entry}->{JoinMessage} . "\n" .
          'Forward email: ' . $response->{Response}->{Entry}->{ForwardEmail} . "\n" .
          'Forward url: ' . $response->{Response}->{Entry}->{ForwardUrl} . "\n" .
          'Groups: ' . join(', ', @{$response->{Response}->{Entry}->{ContactGroupIDs}})."\n";
} else {
    foreach $err (@{$response->{Response}->{Errors}}) {
        print 'Error: ' . $err . "\n";
    }
}

      

