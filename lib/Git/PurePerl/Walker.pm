use 5.008;    #utf8
use strict;
use warnings;
use utf8;

package Git::PurePerl::Walker;

our $VERSION = '0.003000';

# ABSTRACT: Walk over a sequence of commits in a Git::PurePerl repo

# AUTHORITY

use Moose qw( has );
use Path::Class qw( dir );
use Class::Load qw( );
use Git::PurePerl::Walker::Types qw( GPPW_Repository GPPW_Methodish GPPW_Method GPPW_OnCommitish GPPW_OnCommit);
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

B<Mandatory:> An instance of L<< C<Git::PurePerl>|Git::PurePerl >> representing
the repository to work with.

=attr repo

=attrmethod repo

	# Getter
	my $repo = $walker->repo();

=cut

has repo => (
  isa        => GPPW_Repository,
  is         => 'ro',
  lazy_build => 1,
);

=carg method

B<Mandatory:> either a C<Str> describing a Class Name Suffix, or an C<Object>
that C<does>
L<<
C<Git::PurePerl::B<Walker::Role::Method>>|Git::PurePerl::Walker::Role::Method
>>.

If its a C<Str>, the C<Str> will be expanded as follows:

	->new(
		...
		method => 'Foo',
		...
	);

	$className = 'Git::PurePerl::Walker::Method::Foo'

And the resulting class will be loaded, and instantiated for you. ( Assuming of
course, you don't need to pass any fancy args ).

If you need fancy args, or a class outside the
C<Git::PurePerl::B<Walker::Method::>> namespace, constructing the object will
have to be your responsibility.

	->new(
		...
		method => Foo::Class->new(),
		...
	)

=p_attr _method

=p_attrmethod _method

	# Getter
	my $methodish = $walker->_method();

=cut

has _method => (
  init_arg => 'method',
  is       => 'ro',
  isa      => GPPW_Methodish,
  required => 1,
);

=attr method

=attrmethod method

	# Getter
	my $method_object = $walker->method();

=cut

has 'method' => (
  init_arg   => undef,
  is         => 'ro',
  isa        => GPPW_Method,
  lazy_build => 1,
);

=carg on_commit

B<Mandatory:> either a C<Str> that can be expanded in a way similar to that by
L<< C<I<method>>|/method >>, a C<CodeRef>, or an object that C<does> L<<
C<Git::PurePerl::B<Walker::Role::OnCommit>>|Git::PurePerl::Walker::Role::OnCommit
>>.

If passed a C<Str> it will be expanded like so:

	->new(
		...
		on_commit => $str,
		...
	);

	$class = 'Git::PurePerl::Walker::OnCommit::' . $str;

And the resulting class loaded and instantiated.

If passed a C<CodeRef>,
L<<
C<Git::PurePerl::B<Walker::OnCommit::CallBack>>|Git::PurePerl::Walker::OnCommit::CallBack
>> will be loaded and your C<CodeRef> will be passed as an argument.

	->new(
		...
		on_commit => sub {
			my ( $commit ) = @_;

		},
		...
	);

If you need anything fancier, or requiring an unusual namespace, you'll want to
construct the object yourself.

	->new(
		...
		on_commit => Foo::Package->new()
		...
	);


=p_attr _on_commit

=p_attrmethod _on_commit

	# Getter
	my $on_commitish => $walker->_on_commit();

=cut

has '_on_commit' => (
  init_arg => 'on_commit',
  required => 1,
  is       => 'ro',
  isa      => GPPW_OnCommitish,
);

=attr on_commit

=attrmethod on_commit

	# Getter
	my $on_commit_object = $walker->on_commit();

=cut

has 'on_commit' => (
  init_arg   => undef,
  isa        => GPPW_OnCommit,
  is         => 'ro',
  lazy_build => 1,
);

=begin Pod::Coverage

BUILD

=end Pod::Coverage

=cut

sub BUILD {
  my ( $self, ) = @_;
  $self->reset;
  return $self;
}

=p_method _build_repo

=cut

sub _build_repo {
  require Git::PurePerl;
  return Git::PurePerl->new( directory => dir(q[.])->absolute->stringify );
}

=p_method _build_method

=cut

sub _build_method {
  my ($self)   = shift;
  my ($method) = $self->_method;

  if ( not ref $method ) {
    my $method_name = 'Git::PurePerl::Walker::Method::' . $method;
    Class::Load::load_class($method_name);
    $method = $method_name->new();
  }
  return $method->for_repository( $self->repo );
}

=p_method _build_on_commit

=cut

sub _build_on_commit {
  my ($self)      = shift;
  my ($on_commit) = $self->_on_commit;

  if ( ref $on_commit and 'CODE' eq ref $on_commit ) {
    my $on_commit_name = 'Git::PurePerl::Walker::OnCommit::CallBack';
    my $callback       = $on_commit;
    Class::Load::load_class($on_commit_name);
    $on_commit = $on_commit_name->new( callback => $callback, );
  }
  elsif ( not ref $on_commit ) {
    my $on_commit_name = 'Git::PurePerl::Walker::OnCommit::' . $on_commit;
    Class::Load::load_class($on_commit_name);
    $on_commit = $on_commit_name->new();
  }
  return $on_commit->for_repository( $self->repo );
}

=method reset

	$walker->reset();

Reset the walk routine back to the state it was before you walked.

=cut

## no critic (Subroutines::ProhibitBuiltinHomonyms)
sub reset {
  my $self = shift;
  $self->method->reset;
  $self->on_commit->reset;
  return $self;
}

=method step

Increments one step forward in the git history, and dispatches the object to the
C<OnCommit> handlers.

If there are more possible steps to take, it will return a true value.


	while ( $walker->step ) {
		/* Code to execute if walker has more items */
	}

This code is almost identical to:

	while(1) {
		$walker->on_commit->handle( $walker->method->current );

		last if not $walker->method->has_next;

		$walker->method->next;

		/*  Code to execute if walker has more items */
	}


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

	my $steps = $walker->step_all;

Mostly a convenience method to iterate until it can iterate no more, but without
you needing to wrap it in a while() block.

Returns the number of steps executed.

=cut

sub step_all {
  my $self  = shift;
  my $steps = 1;
  while ( $self->step ) {
    $steps++;
  }
  return $steps;
}

__PACKAGE__->meta->make_immutable;
no Moose;

1;
