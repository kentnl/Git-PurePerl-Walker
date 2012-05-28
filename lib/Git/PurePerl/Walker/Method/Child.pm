use strict;
use warnings;
package Git::PurePerl::Walker::Method::Child;
BEGIN {
  $Git::PurePerl::Walker::Method::Child::AUTHORITY = 'cpan:KENTNL';
}
{
  $Git::PurePerl::Walker::Method::Child::VERSION = '0.1.0';
}
# FILENAME: Child.pm
# CREATED: 28/05/12 16:37:28 by Kent Fredric (kentnl) <kentfredric@gmail.com>
# ABSTRACT: Walk down a tree following children.

use Moose;
with qw( Git::PurePerl::Walker::Role::Method );


no Moose;
__PACKAGE__->meta->make_immutable;
1;



__END__
=pod

=head1 NAME

Git::PurePerl::Walker::Method::Child - Walk down a tree following children.

=head1 VERSION

version 0.1.0

=head1 AUTHOR

Kent Fredric <kentnl@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Kent Fredric <kentnl@cpan.org>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

