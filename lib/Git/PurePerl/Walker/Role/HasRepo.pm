use strict;
use warnings;

package Git::PurePerl::Walker::Role::HasRepo;
BEGIN {
  $Git::PurePerl::Walker::Role::HasRepo::AUTHORITY = 'cpan:KENTNL';
}
{
  $Git::PurePerl::Walker::Role::HasRepo::VERSION = '0.1.0';
}

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

__END__
=pod

=head1 NAME

Git::PurePerl::Walker::Role::HasRepo - An entity that has a repo

=head1 VERSION

version 0.1.0

=head1 AUTHOR

Kent Fredric <kentnl@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Kent Fredric <kentnl@cpan.org>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

