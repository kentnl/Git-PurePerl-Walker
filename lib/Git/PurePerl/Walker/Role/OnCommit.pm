use strict;
use warnings;

package Git::PurePerl::Walker::Role::OnCommit;
BEGIN {
  $Git::PurePerl::Walker::Role::OnCommit::AUTHORITY = 'cpan:KENTNL';
}
{
  $Git::PurePerl::Walker::Role::OnCommit::VERSION = '0.002000';
}

# FILENAME: OnCommit.pm
# CREATED: 28/05/12 16:35:27 by Kent Fredric (kentnl) <kentfredric@gmail.com>
# ABSTRACT: An event to execute when a commit is encountered

use Moose::Role;


with 'Git::PurePerl::Walker::Role::HasRepo';





requires 'handle';


requires 'reset';
no Moose::Role;
1;

__END__
=pod

=encoding utf-8

=head1 NAME

Git::PurePerl::Walker::Role::OnCommit - An event to execute when a commit is encountered

=head1 VERSION

version 0.002000

=head1 REQUIRES METHODS

=head2 handle

This is the primary event that is triggered when every commit is processed.

C<handle> is passed a L<<
C<Git::PurePerl::B<Object::Commit>>|Git::PurePerl::Object::Commmit >> for you to
do something with.

	$object->handle( $commit )

=head2 reset

This method is signaled when the associated repository is resetting its iteration. 

You can either no-op this, or make it do something useful.

=head1 INHERITED METHODS

=head2 for_repository

L<< C<Git::PurePerl::B<Walker::Role::HasRepo>-E<gt>I<for_repository( $repo )>>|Git::PurePerl::Walker::Role::HasRepo/for_repository >>

=head2 clone

L<< C<MooseX::B<Clone>-E<gt>I<clone( %params )>>|MooseX::Clone/clone-params >>

=head2 _repo

L<< C<Git::PurePerl::B<Walker::Role::HasRepo>-E<gt>I<_repo( $repo )>>|Git::PurePerl::Walker::Role::HasRepo/_repo >>

=head1 CONSUMED ROLES

=head2 Git::PurePerl::Walker::Role::HasRepo

L<< C<Git::PurePerl::B<Walker::Role::HasRepo>>|Git::PurePerl::Walker::Role::HasRepo >>

=head1 AUTHOR

Kent Fredric <kentnl@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Kent Fredric <kentnl@cpan.org>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

