use strict;
use warnings;

package Git::PurePerl::Walker::Role::Method;
BEGIN {
  $Git::PurePerl::Walker::Role::Method::AUTHORITY = 'cpan:KENTNL';
}
{
  $Git::PurePerl::Walker::Role::Method::VERSION = '0.001000';
}

# FILENAME: Method.pm
# CREATED: 28/05/12 16:33:59 by Kent Fredric (kentnl) <kentfredric@gmail.com>
# ABSTRACT: A method for traversing a git repository

use Moose::Role;


with 'Git::PurePerl::Walker::Role::HasRepo';


requires 'current';


requires 'has_next';


requires 'next';


requires 'peek_next';


requires 'reset';

no Moose::Role;
1;

__END__
=pod

=encoding utf-8

=head1 NAME

Git::PurePerl::Walker::Role::Method - A method for traversing a git repository

=head1 VERSION

version 0.001000

=head1 REQUIRES METHODS

=head2 current

	my $commit = $object->current;

Should return a L<Git::PurePerl::Object::Commit>

=head2 has_next

	if ( $object->has_next ) {

	}

Should return true if C<<->next>> will expose a previously unseen object.

=head2 next

=head2 peek_next

=head2 reset

=head1 CONSUMED ROLES

=head2 Git::PurePerl::Walker::Role::HasRepo

L<Git::PurePerl::Walker::Role::HasRepo>

=head1 AUTHOR

Kent Fredric <kentnl@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Kent Fredric <kentnl@cpan.org>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

