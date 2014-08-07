use strict;
use warnings;

package Git::PurePerl::Walker::Role::HasRepo;

our $VERSION = '0.003000';

# FILENAME: HasRepo.pm
# CREATED: 28/05/12 18:20:41 by Kent Fredric (kentnl) <kentfredric@gmail.com>
# ABSTRACT: An entity that has a repo

=head1 DESCRIPTION

This is a composition role consumed by other roles to provide them with a
private repo property.

This role also folds in L<< C<MooseX::B<Clone>>|MooseX::Clone >> and provides the 'for_repository'
method which sets the repo property.

	package Foo {
		use Moose;
		with 'Git::PurePerl::Walker::Role::HasRepo';
		__PACKAGE__->meta->make_immutable;
	}

	my $factory = Foo->new( %args );

	my $instance = $factory->for_repository( $Git_PurePerl_Repo );


=cut

use Moose::Role;
use Git::PurePerl::Walker::Types qw( GPPW_Repository );

=consumerole MooseX::Clone

L<< C<MooseX::B<Clone>>|MooseX::Clone >>

=cut

=imethod clone

L<< C<MooseX::B<Clone>-E<gt>I<clone( %params )>>|MooseX::Clone/clone-params >>

=cut

with qw( MooseX::Clone );

=p_attr _repo

=cut

=p_attrmethod _repo

=cut

has '_repo' => ( isa => GPPW_Repository, is => 'rw', weak_ref => 1 );

=method for_repository

Construct an entity for a given repository.

This internally calls L<< C<MooseX::B<Clone>>|MooseX::Clone >> on the current object, passing the _repo
field to its constructor, producing a seperate, disconnected object to work
with.

The rationale behind this is simple: Its very likely users will want one set of
settings for a consuming class, but they'll want to use those same settings with
multiple repositories.

And as each repository will need to maintain its own state for traversal, they
have to normally manually construct an object for each repository, manually
disconnecting the constructor arugments.

This instead is simple:

	my $thing = Thing->new( %args );
	my ( @foos  ) = map { $thing->for_repository( $_ ) } @repos;

And now all C<@foos> can be mangled independently.

=cut

sub for_repository {
	my ( $self, $repo ) = @_;
	my $clone = $self->clone( _repo => $repo, );
	return $clone;
}

no Moose::Role;
1;
