package DMT::Engine::Sqlite::Command::dumpdb;

use Moose;
use namespace::autoclean;
use 5.016;
use Data::Dump qw(dump);
use Carp;
use MooseX::Types::Path::Class;
use Path::Class qw(file dir);;

extends 'DMT::Engine::Sqlite::Command';
with 'DMT::Roles::Command::dumpdb';

sub abstract {

    return q(Dump sqlite database schema to a file);
}

has 'dump_dir' => (
    is       => 'ro',
    isa      => 'Path::Class::Dir',
    coerce   => 1,
    required => 1,
    documentation => q(Base Directory to dump the database file schema),
);


sub _get_dump_command {
    my ($self) = @_;
    
    my $sqlite3_dump_command = q(.dump);

    return $self->_get_sqlite3_cli()
         . q( )
         . $self->database
         . q( )
         . $sqlite3_dump_command;
}

sub _dump_database {

	my ($self) = @_;

    $self->logger->info(q(Start));

	$self->dump_dir->mkpath(1)
        if not -d $self->dump_dir->stringify;

	$self->logdie(qq(Could not create dump_dir ) . $self->dump_dir )
        if not -d $self->dump_dir->stringify;

	my $dump_file = file(
            $self->dump_dir->stringify, 
            $self->database->basename 
    );

	my $dump_cmd = $self->_get_dump_command();
       $dump_cmd .= q( > ) . $dump_file;

	$self->_call_run3( $dump_cmd );

    $self->logger->info(q(Done));

	return;
}

__PACKAGE__->meta->make_immutable();

1;


__END__


=head1 NAME

DMT::Engine::Sqlite::dumpdb

=head1 DESCRIPTION

Dump sqlite3 datbase schema to a file

=cut

