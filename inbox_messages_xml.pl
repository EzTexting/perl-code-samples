#!/usr/bin/perl

use warnings;
use strict;
use SmsTextingAPI;
use Data::Dumper;
use feature qw(say);

say 'XML encoding.';
my $sms = new SmsTextingAPI("centerft", "texting121212", SmsTextingAPI::XML, "https://app.eztexting.com");


say 'Get incomingMessages';
my $response =  $sms->getAll(SmsTextingAPI::INCOMING_MESSAGE);
say Dumper($response);

my $incomingMessageId = $response->{Entries}[0]->{ID};
my $incomingMessageId2 = $response->{Entries}[1]->{ID};
my $incomingMessageIdsArray = [$incomingMessageId, $incomingMessageId2];

say 'Move incomingMessages';
$response = $sms->moveMessagesToFolder('88', $incomingMessageIdsArray );
say Dumper($response);


say 'Get incomingMessage';
$response =  $sms->get(SmsTextingAPI::INCOMING_MESSAGE, $incomingMessageId2);
say Dumper($response);


say 'Delete incomingMessage';
$response =  $sms->delete(SmsTextingAPI::INCOMING_MESSAGE, $incomingMessageId);
say Dumper($response);


say 'Second delete. try to get error';
$response =  $sms->delete(SmsTextingAPI::INCOMING_MESSAGE, $incomingMessageId);
say Dumper($response);