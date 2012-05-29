use strict;
use warnings;

package Git::PurePerl::Walker::OnCommit::CallBack;

# FILENAME: CallBack.pm
# CREATED: 28/05/12 18:19:19 by Kent Fredric (kentnl) <kentfredric@gmail.com>
# ABSTRACT: Execute a sub() for each commit

use Moose;
use MooseX::Types::Moose qw( CodeRef );
with qw( Git::PurePerl::Walker::Role::OnCommit );

has callback => (
	handles  => { do_callback => 'execute', },
	is       => 'rw',
	isa      => CodeRef,
	required => 1,
	traits   => [ qw( Code ) ],
);

sub handle {
	my ( $self, $commit ) = @_;
	$self->do_callback( $commit );
	return $self;
}

## no critic ( Subroutines::ProhibitBuiltinHomonyms )
sub reset {
	return shift;
}
## use critic

no Moose;
__PACKAGE__->meta->make_immutable;
1;
