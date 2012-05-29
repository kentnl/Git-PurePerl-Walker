use strict;
use warnings;

package Git::PurePerl::Walker::OnCommit::CallBack;

# FILENAME: CallBack.pm
# CREATED: 28/05/12 18:19:19 by Kent Fredric (kentnl) <kentfredric@gmail.com>
# ABSTRACT: Execute a sub() for each commit

use Moose;
use MooseX::Types::Moose qw( CodeRef );
use namespace::autoclean;

=consumerole Git::PurePerl::Walker::Role::OnCommit

L<< C<Git::PurePerl::B<Walker::Role::OnCommit>>|Git::PurePerl::Walker::Role::OnCommit >>

=cut

with qw( Git::PurePerl::Walker::Role::OnCommit );

=imethod for_repository

L<< C<Git::PurePerl::B<Walker::Role::HasRepo>-E<gt>I<for_repository( $repo )>>|Git::PurePerl::Walker::Role::HasRepo/for_repository >>

=cut

=imethod clone

L<< C<MooseX::B<Clone>-E<gt>I<clone( %params )>>|MooseX::Clone/clone-params >>

=cut

=imethod _repo

L<< C<Git::PurePerl::B<Walker::Role::HasRepo>-E<gt>I<_repo( $repo )>>|Git::PurePerl::Walker::Role::HasRepo/_repo >>

=cut

=attr callback

=attrmethod callback

=attrmethod do_callback

=cut

has callback => (
	handles  => { do_callback => 'execute', },
	is       => 'rw',
	isa      => CodeRef,
	required => 1,
	traits   => [ qw( Code ) ],
);

=rolemethod handle

L<< C<Git::PurePerl::B<Walker::Role::OnCommit>-E<gt>I<handle( $commit )>>|Git::PurePerl::Walker::Role::OnCommit/handle >>

=cut

sub handle {
	my ( $self, $commit ) = @_;
	$self->do_callback( $commit );
	return $self;
}

=rolemethod reset

L<< C<Git::PurePerl::B<Walker::Role::OnCommit>-E<gt>I<reset()>>|Git::PurePerl::Walker::Role::OnCommit/reset >>

=cut

## no critic ( Subroutines::ProhibitBuiltinHomonyms )
sub reset {
	return shift;
}
## use critic

no Moose;
__PACKAGE__->meta->make_immutable;
1;
