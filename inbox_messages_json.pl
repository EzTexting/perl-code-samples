#!/usr/bin/perl

use warnings;
use strict;
use SmsTextingAPI;
use Data::Dumper;
use feature qw(say);

say 'JSON encoding.';
$sms = new SmsTextingAPI("centerft", "texting121212", SmsTextingAPI::JSON, "https://app.eztexting.com");

say 'Get incomingMessages';
$response =  $sms->getAll(SmsTextingAPI::INCOMING_MESSAGE);
say Dumper($response);

$incomingMessageId = $response->{Entries}[0]->{ID};


say 'Move incomingMessage';
$response = $sms->moveMessagesToFolder('75', $incomingMessageId);
say Dumper($response);

say 'Get incomingMessage';
$response =  $sms->get(SmsTextingAPI::INCOMING_MESSAGE, $incomingMessageId);
say Dumper($response);


say 'Delete incomingMessage';
$response =  $sms->delete(SmsTextingAPI::INCOMING_MESSAGE, $incomingMessageId);
say Dumper($response);


say 'Second delete. try to get error';
$response =  $sms->delete(SmsTextingAPI::INCOMING_MESSAGE, $incomingMessageId);
say Dumper($response);