#!/usr/bin/perl
use LWP::UserAgent;
use HTTP::Request::Common qw(POST);
use XML::Simple;

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

my $responde = HTTP::Request->new(POST => "https://app.eztexting.com/keywords/honey?format=xml");
$responde->content_type("application/x-www-form-urlencoded");
$responde->content($params);

$responseObj = $ua->request($responde);

print $responseObj->content."\n--------------------\n";

$responseCode = $responseObj->code;
print 'Response code: ' . $responseCode . "\n";
$isSuccesResponse = $responseCode < 400;

$response = XML::Simple->new->XMLin($responseObj->content);#(ForceArray => 1)

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


      

