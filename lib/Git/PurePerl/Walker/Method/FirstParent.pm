use strict;
use warnings;

package Git::PurePerl::Walker::Method::FirstParent;
BEGIN {
  $Git::PurePerl::Walker::Method::FirstParent::AUTHORITY = 'cpan:KENTNL';
}
{
  $Git::PurePerl::Walker::Method::FirstParent::VERSION = '0.1.0';
}

# FILENAME: FirstParent.pm
# CREATED: 28/05/12 16:37:28 by Kent Fredric (kentnl) <kentfredric@gmail.com>
# ABSTRACT: Walk down a tree following the first parent.

use Moose;
with qw( Git::PurePerl::Walker::Role::Method );

has '_commit' => ( isa => 'Maybe[ Object ]', is => 'rw', lazy_build => 1 );
has 'start'   => ( isa => 'Str',             is => 'rw', required   => 1 );

sub _build__commit {
	my ( $self ) = @_;
	return $self->_repo->get_object( $self->start );
}

sub current {
	my ( $self ) = @_;
	return $self->_commit;
}

sub has_next {
	my ( $self ) = @_;
	if ( not $self->_commit ) {
		return;
	}
	if ( not $self->_commit->parent ) {
		return;
	}
	return 1;
}
## no critic (Subroutines::ProhibitBuiltinHomonyms)
sub next {
	my ( $self ) = @_;
	my $commit;
	$self->_commit( $commit = $self->peek_next );
	return $commit;
}

sub peek_next {
	my $commit = ( shift )->_commit->parent;
	return $commit;
}

sub reset {
	my ( $self ) = @_;
	$self->_commit( $self->_repo->get_object( $self->start ) );
	return $self;
}

no Moose;
__PACKAGE__->meta->make_immutable;
1;

__END__
=pod

=encoding utf-8

=head1 NAME

Git::PurePerl::Walker::Method::FirstParent - Walk down a tree following the first parent.

=head1 VERSION

version 0.1.0

=head1 AUTHOR

Kent Fredric <kentnl@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Kent Fredric <kentnl@cpan.org>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

