use strict;
use warnings;
package Git::PurePerl::Walker::OnCommit::CallBack;
# FILENAME: CallBack.pm
# CREATED: 28/05/12 18:19:19 by Kent Fredric (kentnl) <kentfredric@gmail.com>
# ABSTRACT: Execute a sub() for each commit

use Moose;
use MooseX::Types::Moose qw( CodeRef );
with qw( Git::PurePerl::Walker::Role::OnCommit );

has callback => ( isa => CodeRef , is => 'rw' , required => 1, 

	traits => [qw( Code )],
	handles => {
		do_callback => 'execute',
	},
);

sub reset {

}

sub handle {
	my ( $self, $commit ) = @_;
	$self->do_callback( $commit );

}


no Moose;
__PACKAGE__->meta->make_immutable;
1;


