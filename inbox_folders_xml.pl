#!/usr/bin/perl

use warnings;
use strict;
use SmsTextingAPI;
use Data::Dumper;
use feature qw(say);

say 'XML encoding.';
my $sms = new SmsTextingAPI("centerft", "texting121212", SmsTextingAPI::XML, "https://app.eztexting.com");

say 'Get folders';
my $response =  $sms->getAll(SmsTextingAPI::FOLDER);
say Dumper($response);


say 'Create folder';
$response = $sms->put(SmsTextingAPI::FOLDER,
    'Name'        => 'Custoers');
say Dumper($response);


say 'Get folder';
my $folderId = $response->{Entry}->{ID};
$response =  $sms->get(SmsTextingAPI::FOLDER, $folderId);
say Dumper($response);


say 'Update folder';
my $folder = $response->{Entry};
$folder->{'Name'} = 'Customers2';
$folder->{ID} = $folderId;
$response = $sms->put(SmsTextingAPI::FOLDER, %$folder);
say Dumper($response);


say 'Delete folder';
$response =  $sms->delete(SmsTextingAPI::FOLDER, $folderId);
say Dumper($response);


say 'Second delete. try to get error';
$response =  $sms->delete(SmsTextingAPI::FOLDER, $folderId);
say Dumper($response);