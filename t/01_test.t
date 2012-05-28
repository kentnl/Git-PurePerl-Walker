use strict;
use warnings;

use Test::More;
use FindBin;
use Path::Class qw( dir );

use lib dir($FindBin::Bin)->subdir("tlib")->absolute->stringify;

my $git = dir($FindBin::Bin)->subdir('tgit')->absolute->stringify;

# FILENAME: 01_test.t
# CREATED: 28/05/12 19:23:38 by Kent Fredric (kentnl) <kentfredric@gmail.com>
# ABSTRACT: Basic implementaition tet

use Git::PurePerl::Walker;
use Git::PurePerl::Walker::Method::FirstParent;

use Git::PurePerl;

my $repo = Git::PurePerl->new(
		directory => $git,
);

my $start = $repo->ref_sha1('refs/heads/master');

my @seen_commits;


my $i = Git::PurePerl::Walker->new(
	repo => $repo,
	method => Git::PurePerl::Walker::Method::FirstParent->new(
		start => $start,
	),
	on_commit => sub { 
		my ( $commit ) = @_;
		push @seen_commits, $commit->sha1;
	},
);

is( $i->step_all, 2, '2 steps');
is_deeply( \@seen_commits, 
	[qw( 
		010fb4bcf7d92c031213f43d0130c811cbb355e7
		10003632f7b967108151e20639e4b425c5e4c731
	)],
'Traverse whole tree');
done_testing;


