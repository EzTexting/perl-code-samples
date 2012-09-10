#!/usr/bin/perl

use warnings;
use strict;
use LWP::UserAgent;
use HTTP::Request::Common qw(POST);
use SmsTextingXmlDecoder;
use SmsTextingJsonDecoder;


package SmsTextingAPI;

use constant {
    XML => "xml",
    JSON => "json",
    CONTACT => "/contacts",
    GROUP => "/groups"
};

sub new
{
    my $class = shift;
    my $self = {
        _login     => shift,
        _password  => shift,
        _encoding  => shift,
        _baseUrl   => shift,
    };
    $self->{_decoder} = $self->{_encoding} eq XML ? new SmsTextingXmlDecoder() : new SmsTextingJsonDecoder();
    bless $self, $class;
    return $self;
}

# get object by id
# which can be GROUP or CONTACT
sub get {
    my ( $self, $which, $id ) = @_;
    return $self->_get($which."/".$id);
}

# get array of objects
# which can be GROUP or CONTACT
# options depends on type of objects
# Common:
# Sorting
#  sortBy (Optional) Property to sort by.
#  sortDir (Optional) Direction of sorting. Available values: asc, desc
# Pagination
#  itemsPerPage (Optional) Number of results to retrieve. By default, 10 most recently added contacts are retrieved.
#  page (Optional) Page of results to retrieve
# Additional contact options:
# Filters
#  query (Optional) Search contacts by first name / last name / phone number
#  source (Optional) Source of contacts. Available values: 'Unknown', 'Manually Added', 'Upload', 'Web Widget', 'API', 'Keyword'
#  optout (Optional) Opted out / opted in contacts. Available values: true, false.
#  group (Optional) Name of the group the contacts belong to
sub getAll {
    my $self = shift;
    my $which = shift;
    return $self->_get($which, @_);
}


# Create or update the object
# which can be GROUP or CONTACT
sub put {
    my $self = shift;
    my $which = shift;
    my %params = @_;
    if ($params{'ID'})
    {
        $which = $which."/".$params{'ID'};
        delete $params{'ID'};
    }
    return $self->_post($which, %params);
}

# Delete object by id
# which can be GROUP or CONTACT
sub delete {
    my ( $self, $which, $id ) = @_;
    return $self->_post($which."/".$id, '_method' =>'DELETE');
}


sub _get {
    my ( $self, $path, %params ) = @_;
    my $uri = URI->new_abs( $path, $self->{_baseUrl} );
    $uri->query_form(User => $self->{_login}, Password => $self->{_password}, format => $self->{_encoding}, %params);
    my $ua = new LWP::UserAgent(keep_alive=>1);
    my $responde = HTTP::Request->new(GET => $uri);
    my $responseObj = $ua->request($responde);
    my $responseCode = $responseObj->code;
    return $self->{_decoder}->decode($responseObj->content) if ($responseCode >=200 && $responseCode<500);
    return { Code => $responseCode, Content => $responseObj->content };
}

sub _post {
    my ( $self, $path, %params ) = @_;
    my $uri = URI->new_abs( $path, $self->{_baseUrl} );
    my $ua = new LWP::UserAgent(keep_alive=>1);
    my $responde = HTTP::Request->new(POST => $uri);

    while ( my ($key, $value) = each(%params) ) {
        if (ref($value) eq 'ARRAY')
        {
            foreach (0..$#{$value}) 
            {
                 $params{$key."[".$_."]"} =  $value->[$_];
            }
            delete $params{$key};
        }
    }
    my $responseObj = $ua->post($uri, { User => $self->{_login}, Password => $self->{_password}, format => $self->{_encoding}, %params } );
    my $responseCode = $responseObj->code;
    return $self->{_decoder}->decode($responseObj->content) if ($responseCode != 204 && $responseCode >= 200 && $responseCode<500);
    return { Code => $responseCode, Content => $responseObj->content };
}
1;