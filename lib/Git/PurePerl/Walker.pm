use strict;
use warnings;

package Git::PurePerl::Walker;
BEGIN {
  $Git::PurePerl::Walker::AUTHORITY = 'cpan:KENTNL';
}
{
  $Git::PurePerl::Walker::VERSION = '0.001001';
}

# ABSTRACT: Walk over a sequence of commits in a Git::PurePerl repo

use Moose;
use Path::Class qw( dir );
use Class::Load qw( );
use Git::PurePerl::Walker::Types qw( :all );
use namespace::autoclean;



has repo => (
	isa        => GPPW_Repository,
	is         => 'rw',
	lazy_build => 1,
);


has _method => (
	init_arg => 'method',
	is       => 'ro',
	isa      => GPPW_Methodish,
	required => 1,
);


has 'method' => (
	init_arg   => undef,
	is         => 'ro',
	isa        => GPPW_Method,
	lazy_build => 1,
);


has '_on_commit' => (
	init_arg => 'on_commit',
	required => 1,
	is       => 'ro',
	isa      => GPPW_OnCommitish,
);


has 'on_commit' => (
	init_arg   => undef,
	isa        => GPPW_OnCommit,
	is         => 'ro',
	lazy_build => 1,
);


sub BUILD {
	my ( $self, $args ) = @_;
	$self->reset;
	return $self;
}


sub _build_repo {
	my ( $self ) = shift;
	require Git::PurePerl;
	return Git::PurePerl->new( directory => dir( q[.] )->absolute->stringify );
}


sub _build_method {
	my ( $self )   = shift;
	my ( $method ) = $self->_method;

	if ( not ref $method ) {
		my $method_name = 'Git::PurePerl::Walker::Method::' . $method;
		Class::Load::load_class( $method_name );
		$method = $method_name->new();
	}
	return $method->for_repository( $self->repo );
}


sub _build_on_commit {
	my ( $self )      = shift;
	my ( $on_commit ) = $self->_on_commit;

	if ( ref $on_commit and ref $on_commit eq 'CODE' ) {
		my $on_commit_name = 'Git::PurePerl::Walker::OnCommit::CallBack';
		my $callback       = $on_commit;
		Class::Load::load_class( $on_commit_name );
		$on_commit = $on_commit_name->new( callback => $callback, );
	}
	elsif ( not ref $on_commit ) {
		my $on_commit_name = 'Git::PurePerl::Walker::OnCommit::' . $on_commit;
		Class::Load::load_class( $on_commit_name );
		$on_commit = $on_commit_name->new();
	}
	return $on_commit->for_repository( $self->repo );
}


## no critic (Subroutines::ProhibitBuiltinHomonyms)
sub reset {
	my $self = shift;
	$self->method->reset;
	$self->on_commit->reset;
	return $self;
}


sub step {
	my $self = shift;

	$self->on_commit->handle( $self->method->current );

	if ( not $self->method->has_next ) {
		return;
	}

	$self->method->next;

	return 1;
}


sub step_all {
	my $self  = shift;
	my $steps = 1;
	while ( $self->step ) {
		$steps++;
	}
	return $steps;
}

1;

__END__
=pod

=encoding utf-8

=head1 NAME

Git::PurePerl::Walker - Walk over a sequence of commits in a Git::PurePerl repo

=head1 VERSION

version 0.001001

=head1 SYNOPSIS

	use Git::PurePerl::Walker;
	use Git::PurePerl::Walker::Method::FirstParent;

	my $repo = Git::PurePerl->new( ... );

	my $walker = Git::PurePerl::Walker->new(
		repo => $repo,
		method => Git::PurePerl::Walker::Method::FirstParent->new( 
			start => $repo->ref_sha1('refs/heads/master'),
		),
		on_commit => sub {
			my ( $commit ) = @_;
			print $commit->sha1;
		},
	);

	$walker->step_all;

=head1 METHODS

=head2 BUILD

=head2 reset

=head2 step

=head2 step_all

=head1 CONSTRUCTOR ARGUMENTS

=head2 repo

=head2 method

=head2 on_commit

=head1 ATTRIBUTES

=head2 repo

=head2 method

=head2 on_commit

=head1 ATTRIBUTE GENERATED METHODS

=head2 repo

=head2 method

=head2 on_commit

=head1 PRIVATE ATTRIBUTES

=head2 _method

=head2 _on_commit

=head1 PRIVATE METHODS

=head2 _build_repo

=head2 _build_method

=head2 _build_on_commit

=head1 PRIVATE ATTRIBUTE GENERATED METHODS

=head2 _method

=head2 _on_commit

=head1 AUTHOR

Kent Fredric <kentnl@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Kent Fredric <kentnl@cpan.org>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

