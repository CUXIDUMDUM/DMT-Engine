package DMT::Engine::Mysql::Command::createdb;

use Moose;
use namespace::autoclean;
use 5.019;
use Data::Dump qw(dump);
use Carp;

extends 'DMT::Engine::Mysql::Command';
with 'DMT::Roles::Command::createdb';

has 'database' => (
    is => 'ro',
    isa => 'Str',
    required => 1,
);

sub _get_create_ddl {
    my ($self) = @_;

    return q(') . q(CREATE DATABASE ) . $self->database . q(');
}

sub _create_database_command {
    my ($self) = @_;

    my $cli = $self->_get_mysql_cli();
    $cli .= q( --batch -e ) . $self->_get_create_ddl();

    return $cli;
}

sub _create_database {
    my ($self) = @_;

    $self->_call_run3( $self->_create_database_command() );
}

1;