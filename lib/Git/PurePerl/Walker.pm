use strict;
use warnings;

package Git::PurePerl::Walker;

# ABSTRACT: Walk over a sequence of commits in a Git::PurePerl repo

use Moose;
use Path::Class qw( dir );
use Class::Load qw( );
use Git::PurePerl::Walker::Types qw( :all );
use namespace::autoclean;

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

=cut

=carg repo

=attr repo

=attrmethod repo

=cut

has repo => (
	isa        => GPPW_Repository,
	is         => 'rw',
	lazy_build => 1,
);

=carg method

=p_attr _method

=p_attrmethod _method

=cut

has _method => (
	init_arg => 'method',
	is       => 'ro',
	isa      => GPPW_Methodish,
	required => 1,
);

=attr method

=attrmethod method

=cut

has 'method' => (
	init_arg   => undef,
	is         => 'ro',
	isa        => GPPW_Method,
	lazy_build => 1,
);

=carg on_commit

=p_attr _on_commit

=p_attrmethod _on_commit

=cut

has '_on_commit' => (
	init_arg => 'on_commit',
	required => 1,
	is       => 'ro',
	isa      => GPPW_OnCommitish,
);

=attr on_commit

=attrmethod on_commit

=cut

has 'on_commit' => (
	init_arg   => undef,
	isa        => GPPW_OnCommit,
	is         => 'ro',
	lazy_build => 1,
);

=method BUILD

=cut

sub BUILD {
	my ( $self, $args ) = @_;
	$self->reset;
	return $self;
}

=p_method _build_repo

=cut

sub _build_repo {
	my ( $self ) = shift;
	require Git::PurePerl;
	return Git::PurePerl->new( directory => dir( q[.] )->absolute->stringify );
}

=p_method _build_method

=cut

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

=p_method _build_on_commit

=cut

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

=method reset

=cut

## no critic (Subroutines::ProhibitBuiltinHomonyms)
sub reset {
	my $self = shift;
	$self->method->reset;
	$self->on_commit->reset;
	return $self;
}

=method step

=cut

sub step {
	my $self = shift;

	$self->on_commit->handle( $self->method->current );

	if ( not $self->method->has_next ) {
		return;
	}

	$self->method->next;

	return 1;
}

=method step_all

=cut

sub step_all {
	my $self  = shift;
	my $steps = 1;
	while ( $self->step ) {
		$steps++;
	}
	return $steps;
}

1;
