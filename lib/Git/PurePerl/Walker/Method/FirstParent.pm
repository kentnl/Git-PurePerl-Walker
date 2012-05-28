use strict;
use warnings;

package Git::PurePerl::Walker::Method::FirstParent;

# FILENAME: FirstParent.pm
# CREATED: 28/05/12 16:37:28 by Kent Fredric (kentnl) <kentfredric@gmail.com>
# ABSTRACT: Walk down a tree following children.

use Moose;
with qw( Git::PurePerl::Walker::Role::Method );

has 'start' => ( isa => 'Str', is => 'rw', required => 1 );
has '_commit' => ( isa => 'Maybe[ Object ]', is => 'rw', lazy_build => 1);

sub _build__commit {
	my ($self )= @_;
	return $self->_repo->get_object( $self->start ) ;
}
sub reset {
    my ($self) = @_;
    $self->_commit( $self->_repo->get_object( $self->start ) );
    return $self;
}

sub current {
	my ( $self ) = @_;
	return $self->_commit;
}
sub next {
    my ($self) = @_;
    my $commit = $self->_commit->parent;
    $self->_commit($commit);
    return $commit;
}
sub has_next {
	my ( $self ) = @_;
	if ( not $self->_commit ) {
		return undef;
	}
	return 1;
}

no Moose;
__PACKAGE__->meta->make_immutable;
1;

