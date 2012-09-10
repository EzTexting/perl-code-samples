#!/usr/bin/perl

use warnings;
use strict;
use SmsTextingAPI;
use Data::Dumper;
use feature qw(say);

say 'XML encoding.';
my $sms = new SmsTextingAPI("demouser", "password", SmsTextingAPI::XML, "https://app.eztexting.com");

say 'Get contacts';
my $response =  $sms->getAll(SmsTextingAPI::CONTACT, 
    'source'        => 'upload',
    'optout'        => 'false',
    'group'         => 'Honey Lovers',
    'sortBy'        => 'PhoneNumber',
    'sortDir'       => 'asc',
    'itemsPerPage'  => '10',
    'page'          => '3');
say Dumper($response);


say 'Create contact';
$response = $sms->put(SmsTextingAPI::CONTACT,
    'PhoneNumber' => '2123456945',
    'FirstName'   => 'Piglet',
    'LastName'    => 'P.',
    'Email'       => 'piglet@small-animals-alliance.org',
    'Note'        => 'It is hard to be brave, when you are only a Very Small Animal.',
    'Groups'   => ['Friends', 'Neighbors']);
say Dumper($response);


say 'Get contact';
my $contactId = $response->{Entry}->{ID};
$response =  $sms->get(SmsTextingAPI::CONTACT, $contactId);
say Dumper($response);


say 'Update contact';
my $contact = $response->{Entry};
$contact->{'LastName'} = 'test';
$response = $sms->put(SmsTextingAPI::CONTACT, %$contact);
say Dumper($response);


say 'Delete contact';
$response =  $sms->delete(SmsTextingAPI::CONTACT, $contactId);
say Dumper($response);


say 'Second delete. try to get error';
$response =  $sms->delete(SmsTextingAPI::CONTACT, $contactId);
say Dumper($response);
                     