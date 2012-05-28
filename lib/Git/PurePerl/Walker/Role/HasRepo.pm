use strict;
use warnings;
package Git::PurePerl::Walker::Role::HasRepo;
# FILENAME: HasRepo.pm
# CREATED: 28/05/12 18:20:41 by Kent Fredric (kentnl) <kentfredric@gmail.com>
# ABSTRACT: An entity that has a repo

use Moose::Role;
with qw( MooseX::Clone );

has '_repo' => ( isa => 'Object', is => 'rw', weak_ref => 1 );

sub for_repository {
    my ( $self, $repo ) = @_;
    my $clone = $self->clone( _repo => $repo, );
    return $clone;
}

no Moose::Role;
1;


