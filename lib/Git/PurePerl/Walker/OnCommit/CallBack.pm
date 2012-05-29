use strict;
use warnings;

package Git::PurePerl::Walker::OnCommit::CallBack;
BEGIN {
  $Git::PurePerl::Walker::OnCommit::CallBack::AUTHORITY = 'cpan:KENTNL';
}
{
  $Git::PurePerl::Walker::OnCommit::CallBack::VERSION = '0.1.0';
}

# FILENAME: CallBack.pm
# CREATED: 28/05/12 18:19:19 by Kent Fredric (kentnl) <kentfredric@gmail.com>
# ABSTRACT: Execute a sub() for each commit

use Moose;
use MooseX::Types::Moose qw( CodeRef );
with qw( Git::PurePerl::Walker::Role::OnCommit );

has callback => (
	handles  => { do_callback => 'execute', },
	is       => 'rw',
	isa      => CodeRef,
	required => 1,
	traits   => [ qw( Code ) ],
);

sub handle {
	my ( $self, $commit ) = @_;
	$self->do_callback( $commit );

}

sub reset {

}

no Moose;
__PACKAGE__->meta->make_immutable;
1;

__END__
=pod

=encoding utf-8

=head1 NAME

Git::PurePerl::Walker::OnCommit::CallBack - Execute a sub() for each commit

=head1 VERSION

version 0.1.0

=head1 AUTHOR

Kent Fredric <kentnl@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Kent Fredric <kentnl@cpan.org>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

