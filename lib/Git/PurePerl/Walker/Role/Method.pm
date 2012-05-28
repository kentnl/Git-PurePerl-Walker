use strict;
use warnings;
package Git::PurePerl::Walker::Role::Method;
BEGIN {
  $Git::PurePerl::Walker::Role::Method::AUTHORITY = 'cpan:KENTNL';
}
{
  $Git::PurePerl::Walker::Role::Method::VERSION = '0.1.0';
}

# FILENAME: Method.pm
# CREATED: 28/05/12 16:33:59 by Kent Fredric (kentnl) <kentfredric@gmail.com>
# ABSTRACT: A method for traversing a git repository

use Moose::Role;
with 'Git::PurePerl::Walker::Role::HasRepo';
requires 'reset';
requires 'next';
requires 'current';
requires 'has_next';
requires 'peek_next';

no Moose::Role;
1;



__END__
=pod

=head1 NAME

Git::PurePerl::Walker::Role::Method - A method for traversing a git repository

=head1 VERSION

version 0.1.0

=head1 AUTHOR

Kent Fredric <kentnl@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Kent Fredric <kentnl@cpan.org>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

