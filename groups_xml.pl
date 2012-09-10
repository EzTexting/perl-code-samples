#!/usr/bin/perl

use warnings;
use strict;
use SmsTextingAPI;
use Data::Dumper;
use feature qw(say);

say 'XML encoding.';
my $sms = new SmsTextingAPI("demouser", "password", SmsTextingAPI::XML, "https://app.eztexting.com");

say 'Get groups';
my $response =  $sms->getAll(SmsTextingAPI::GROUP, 'sortBy' => 'Name');
say Dumper($response);


say 'Create group';
$response = $sms->put(SmsTextingAPI::GROUP,
    'Name'        => 'Tubby Bears',
    'Note'        => 'A bear, however hard he tries, grows tubby without exercise');
say Dumper($response);


say 'Get group';
my $groupId = $response->{Entry}->{ID};
$response =  $sms->get(SmsTextingAPI::GROUP, $groupId);
say Dumper($response);


say 'Update group';
my $group = $response->{Entry};
$group->{'Note'} = 'test';
$response = $sms->put(SmsTextingAPI::GROUP, %$group);
say Dumper($response);


say 'Delete group';
$response =  $sms->delete(SmsTextingAPI::GROUP, $groupId);
say Dumper($response);


say 'Second delete. try to get error';
$response =  $sms->delete(SmsTextingAPI::GROUP, $groupId);
say Dumper($response);

