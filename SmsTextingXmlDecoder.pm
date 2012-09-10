#!/usr/bin/perl

use warnings;
use strict;
use XML::Simple;

package SmsTextingXmlDecoder;

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
    my $response = XML::Simple->new->XMLin($content);
    $self->_updateGroups($response->{Entry}) if ($response->{Entry});
    if ($response->{Entries} && $response->{Entries}->{Entry})
    {
       if (ref($response->{Entries}->{Entry}) eq 'ARRAY')
       {
           $response->{Entries} = $response->{Entries}->{Entry};
       }
       else
       {
           $response->{Entries} = [$response->{Entries}->{Entry}];
       }

       $self->_updateGroups($_) for (@{$response->{Entries}});
    }

    if ($response->{Errors} && $response->{Errors}->{Error})
    {
       if (ref($response->{Errors}->{Error}) eq 'ARRAY')
       {
           $response->{Errors} = $response->{Errors}->{Error};
       }
       else
       {
           $response->{Errors} = [$response->{Errors}->{Error}];
       }
    }

    return $response;
}

sub _updateGroups
{
    my $self = shift;
    my $entry = shift;
    if ($entry && $entry->{Groups} && $entry->{Groups}->{Group})
    {
       if (ref($entry->{Groups}->{Group}) eq 'ARRAY')
       {
           $entry->{Groups} = $entry->{Groups}->{Group};
       }
       else
       {
           $entry->{Groups} = [$entry->{Groups}->{Group}];
       }
    }
}
1;

