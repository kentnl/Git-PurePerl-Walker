use strict;
use warnings;

package Git::PurePerl::Walker::Role::OnCommit;
BEGIN {
  $Git::PurePerl::Walker::Role::OnCommit::AUTHORITY = 'cpan:KENTNL';
}
{
  $Git::PurePerl::Walker::Role::OnCommit::VERSION = '0.1.0';
}

# FILENAME: OnCommit.pm
# CREATED: 28/05/12 16:35:27 by Kent Fredric (kentnl) <kentfredric@gmail.com>
# ABSTRACT: An event to execute when a commit is encountered

use Moose::Role;
with 'Git::PurePerl::Walker::Role::HasRepo';
requires 'reset';
requires 'handle';

no Moose::Role;
1;

__END__
=pod

=head1 NAME

Git::PurePerl::Walker::Role::OnCommit - An event to execute when a commit is encountered

=head1 VERSION

version 0.1.0

=head1 AUTHOR

Kent Fredric <kentnl@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Kent Fredric <kentnl@cpan.org>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

