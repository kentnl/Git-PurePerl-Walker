use strict;
use warnings;
package Git::PurePerl::Walker::Method::FirstParent::FromHEAD;

# FILENAME: FromHEAD.pm
# CREATED: 30/05/12 13:57:49 by Kent Fredric (kentnl) <kentfredric@gmail.com>
# ABSTRACT: Start at the HEAD of the current repo.

use Moose;
extends 'Git::PurePerl::Walker::Method::FirstParent';

has '+start' => (
	lazy_build => 1,
	required => 0,
);

has '+_repo' => (
	predicate => '_has_repo',
);

sub _build_start {
	my $self = shift;
	unless ( $self->_has_repo ) {
		die "No repo defined while trying to find a starting commit";
	}
	return $self->_repo->head_sha1;
}

no Moose;
__PACKAGE__->meta->make_immutable;
1;


