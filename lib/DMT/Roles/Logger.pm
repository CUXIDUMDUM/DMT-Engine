package DMT::Roles::Logger;

use strict;
use warnings;
use 5.016;

use English qw( -no_match_vars );
use Carp;
use Readonly;
use Data::Dump qw(dump);
use Log::Log4perl;

use Moose::Role;
use namespace::autoclean;
use MooseX::StrictConstructor;
use MooseX::Types::Path::Class;

has 'logger' => (
    is         => 'ro',
    isa        => 'Log::Log4perl::Logger',
    lazy_build => 1,
);

has 'log4perl_conf' => (
    is        => 'rw',
    isa       => 'Str',
    default   => q(etc/log4perl.conf),
    predicate => 'has_log4perl_conf',
);

sub _build_logger {
    my ($self) = @_; 
    my $log = Log::Log4perl::Logger->get_logger(__PACKAGE__);

    unless ( Log::Log4perl->initialized() ) { 
        if ( $self->has_log4perl_conf and -e $self->log4perl_conf ) { 
            Log::Log4perl->init( $self->log4perl_conf );
        }   
        else {
            Log::Log4perl->easy_init();
        }   
    }   
    return $log;
}

1;

__END__

=head1 NAME

foo - Abstract

=head1 VERSION

0.01

=cut

=head1 SYNOPSIS


=head1 DESCRIPTION

<foo> -

=head1 METHODS

=over 4

=item function(arg1,arg2)


=item function1(arg1,arg2)
