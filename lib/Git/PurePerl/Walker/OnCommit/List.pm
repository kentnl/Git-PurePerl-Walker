use strict;
use warnings;

package Git::PurePerl::Walker::OnCommit::List;

# FILENAME: CallBack.pm
# CREATED: 28/05/12 18:19:19 by Kent Fredric (kentnl) <kentfredric@gmail.com>
# ABSTRACT: Execute an ordered list of OnCommit events.

use Moose;
use MooseX::Types::Moose qw( ArrayRef );
use Git::PurePerl::Walker::Types qw( GPPW_OnCommit );

=consumerole Git::PurePerl::Walker::Role::OnCommit

L<< C<Git::PurePerl::B<Walker::Role::OnCommit>>|Git::PurePerl::Walker::Role::OnCommit >>

=cut

with qw( Git::PurePerl::Walker::Role::OnCommit );

=attr events

=attrmethod all_events

=attrmethod add_event

=cut

has 'events' => (
	isa => ArrayRef [ GPPW_OnCommit ],
	is => 'rw',
	handles => {
		all_events => 'elements',
		add_event  => 'push',
	},
	traits  => [ qw( Array ) ],
	default => sub { [] },
);

=rolemethod handle

L<< C<Git::PurePerl::B<Walker::Role::OnCommit>-E<gt>I<handle( $commit )>>|Git::PurePerl::Walker::Role::OnCommit/handle >>

=cut

sub handle {
	my ( $self, $commit ) = @_;
	for my $child ( $self->all_events ) {
		$child->handle( $commit );
	}
	return $self;
}

=rolemethod reset

L<< C<Git::PurePerl::B<Walker::Role::OnCommit>-E<gt>I<reset()>>|Git::PurePerl::Walker::Role::OnCommit/reset >>

=cut

## no critic ( Subroutines::ProhibitBuiltinHomonyms )
sub reset {
	my ( $self, ) = @_;
	for my $child ( $self->events ) {
		$child->reset();
	}
	return $self;
}
## use critic

around add_event => sub {
	my ( $orig, $self, @args ) = @_;
	if ( not $self->_repo ) {
		return $orig->( $self, @args );
	}
	my ( @new ) = map { $_->for_repository( $self->_repo ) } @args;
	return $orig->( $self, @new );

};
around for_repository => sub {
	my ( $orig, $self, @args ) = @_;
	my $new = $self->$orig( @args );
	$new->events( [ map { $_->for_repository( $args[ 0 ] ) } $self->all_events ] );
	return $new;
};

no Moose;
__PACKAGE__->meta->make_immutable;
1;
