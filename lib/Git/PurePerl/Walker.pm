use strict;
use warnings;
package Git::PurePerl::Walker;
BEGIN {
  $Git::PurePerl::Walker::AUTHORITY = 'cpan:KENTNL';
}
{
  $Git::PurePerl::Walker::VERSION = '0.001';
}

# ABSTRACT: Walk over a sequence of commits in a Git::PurePerl repo

use Moose;
use Path::Class qw( dir );
use Class::Load qw( );
use Git::PurePerl::Walker::Types qw( :all );
require Moose::Util::TypeConstraints;

has repo => ( 
	isa => GPPW_Repository,
	is => 'rw',
	lazy_build => 1,
);

has _method => (
	init_arg => 'method',
	is => 'ro',
	isa => GPPW_Methodish,
	required  => 1,
);
has 'method' => (
	init_arg => undef,
	is => 'ro',
	isa =>  GPPW_Method,
	lazy_build => 1,
);

has '_on_commit' => (
	init_arg => 'on_commit',
	required => 1,
	is => 'ro',
	isa =>  GPPW_OnCommitish,
);
has 'on_commit' => (
	init_arg => undef,
	isa =>  GPPW_OnCommit,
	is => 'ro',
	lazy_build => 1,
);
sub BUILD{
	my ( $self, $args ) = @_;
	$self->reset;
};


sub _build_repo {
	my ( $self ) = shift;
	require Git::PurePerl;
	return Git::PurePerl->new( 
		directory => dir('.')->absolute->stringify
	);
}

sub _build_method {
	my ( $self ) = shift;
	my ( $method ) = $self->_method;

	if ( not ref $method ){
		my $method_name = 'Git::PurePerl::Walker::Method::' . $method ;
		Class::Load::load_class($method_name);
		$method = $method_name->new();
	}
	return $method->for_repository( $self->repo );
}
sub _build_on_commit {
	my ( $self ) = shift;
	my ( $on_commit) = $self->_on_commit;

	if ( ref $on_commit and ref $on_commit eq 'CODE' ) {
		my $on_commit_name = 'Git::PurePerl::Walker::OnCommit::CallBack';
		my $callback = $on_commit;
		Class::Load::load_class($on_commit_name);
		$on_commit = $on_commit_name->new(
			callback => $callback,
		);
	} elsif ( not ref $on_commit ){
		my $on_commit_name = 'Git::PurePerl::Walker::OnCommit::' . $on_commit ;
		Class::Load::load_class($on_commit_name);
		$on_commit = $on_commit_name->new();
	}
	return $on_commit->for_repository( $self->repo );
}
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
	my $self = shift;
	my $steps  = 1;
	while( $self->step ){
		$steps++;
	}
	return $steps;
}

1;

__END__
=pod

=head1 NAME

Git::PurePerl::Walker - Walk over a sequence of commits in a Git::PurePerl repo

=head1 VERSION

version 0.001

=head1 AUTHOR

Kent Fredric <kentnl@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Kent Fredric <kentnl@cpan.org>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

