#!/usr/bin/perl

use warnings;
use strict;
use SmsTextingAPI;
use Data::Dumper;
use feature qw(say);


say 'JSON encoding.';
$sms = new SmsTextingAPI("demouser", "password", SmsTextingAPI::JSON, "https://app.eztexting.com");

say 'Get groups';
$response =  $sms->getAll(SmsTextingAPI::GROUP, 'sortBy' => 'Name');
say Dumper($response);


say 'Create group';
$response = $sms->put(SmsTextingAPI::GROUP,
    'Name'        => 'Tubby Bears',
    'Note'        => 'A bear, however hard he tries, grows tubby without exercise');
say Dumper($response);


say 'Get group';
$groupId = $response->{Entry}->{ID};
$response =  $sms->get(SmsTextingAPI::GROUP, $groupId);
say Dumper($response);


say 'Update group';
$group = $response->{Entry};
$group->{'Note'} = 'test';
$response = $sms->put(SmsTextingAPI::GROUP, %$group);
say Dumper($response);


say 'Delete group';
$response =  $sms->delete(SmsTextingAPI::GROUP, $groupId);
say Dumper($response);


say 'Second delete. try to get error';
$response =  $sms->delete(SmsTextingAPI::GROUP, $groupId);
say Dumper($response);
