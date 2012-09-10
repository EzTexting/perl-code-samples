#!/usr/bin/perl

use warnings;
use strict;
use JSON::XS;

package SmsTextingJsonDecoder;

sub new
{
    my $class = shift;
    my $self = {};
    bless $self, $class;
    return $self;
}

sub decode
{
    my $self = shift;
    my $content = shift;
    my $response = JSON::XS->new->decode ($content);
    return $response->{Response};
}

1;