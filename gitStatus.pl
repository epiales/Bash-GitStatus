#!/usr/local/bin/perl

use strict;
use warnings;

my $status = `git status --porcelain -b 2> /dev/null`;

# if there is no status information, exit
if ( $status eq "" ) {
	exit 0;
}

# branch
my $branch           = ""; # branch name
my $aheadBehind      = ""; # `ahead` or `behind` remote tracking branch
my $aheadBehindCount = 0;  # commits ahead / behind remote tracking branch
my $remote           = ""; # remote tracking branch name
my $remoteTracking   = ""; # `ahead` or `behind` the remote
my $remoteCount      = 0;  # commits ahead / behind

# staged
my $deletedStaged  = 0; # deleted
my $modifiedStaged = 0; # modified / renamed files
my $addedCount     = 0; # new files
my $staged         = 0;

# unstaged
my $deletedUnstaged  = 0; # deleted files
my $modifiedUnstaged = 0; # modified files
my $untrackedCount   = 0; # new files
my $unstaged         = 0;

my @arr = split( '\n', $status );

foreach ( @arr ) {
	
	# branch name
	if( $_ =~ m/^##/ ) {
		$_ =~ s/^##\s//g;

		if ( $_ =~ /\[(\w+)\s(\d+)(,\s(\w+)\s(\d+))?/ ) {
			$aheadBehind      = $1;
			$aheadBehindCount = $2;

			if ( $4 && $5 ) {
				$remoteTracking = $4;
				$remoteCount    = $5;
			}
		}

		$_ =~ /(\w+)(\.{3}([\w\/]+))?/;
		$branch = $1;

		if ( $3 ) { $remote = $3; }
	}

	# unstaged new files
	elsif ( $_ =~ m/^\?\?/ ) {
		if ( !$unstaged ) { $unstaged = 1; }
		$untrackedCount++;
	}

	# unstaged modified files
	elsif( $_ =~ m/^\sM/ ) {
		if ( !$unstaged ) { $unstaged = 1; }
		$modifiedUnstaged++;
	}

	# unstaged deleted files
	elsif( $_ =~ m/^\sD/ ) {
		if ( !$unstaged ) { $unstaged = 1; }
		$deletedUnstaged++;
	}

	# staged new files
	elsif ( $_ =~ m/^A\s\s/ ) {
		if ( !$staged ) { $staged = 1; }
		$addedCount++;
	}

	# staged modified / renamed files
	elsif( $_ =~ m/^(M|R|C)\s/ ) {
		if ( !$staged ) { $staged = 1; }
		$modifiedStaged++;
	}

	# staged deleted files
	elsif ( $_ =~ m/^D\s/ ) {
		if ( !$staged ) { $staged = 1; }
		$deletedStaged++;
	}

}

use Term::ANSIColor qw(:constants);
{
	print BOLD YELLOW "[ ";

	if ( $aheadBehind eq "ahead" ) {
		print BOLD BLUE "$branch+$aheadBehindCount";
	} elsif ( $aheadBehind eq "behind" ) {
		print BOLD RED "$branch-$aheadBehindCount";
	} else {
		print BOLD CYAN "$branch";
	}

	if ( $remoteTracking eq "ahead" ) {
		print WHITE " ~^~ ";
		print BOLD BLUE "$remote+$remoteCount";
	} elsif ( $remoteTracking eq "behind" ) {
		print WHITE " ~^~ ";
		print BOLD RED "$remote-$remoteCount";
	}

	if ( $staged || $unstaged ) {
		print BOLD YELLOW " |";
	}

	if ( $deletedStaged ) {
		print BOLD GREEN " -$deletedStaged";
	}

	if ( $modifiedStaged ) {
		print BOLD GREEN " ~$modifiedStaged";
	}

	if ( $addedCount ) {
		print BOLD GREEN " +$addedCount";
	}

	if ( $staged && $unstaged ) {
		print BOLD YELLOW " |";
	}

	if ( $deletedUnstaged ) {
		print BOLD RED " -$deletedUnstaged";
	}

	if ( $modifiedUnstaged ) {
		print BOLD RED " ~$modifiedUnstaged";
	}

	if ( $untrackedCount ) {
		print BOLD RED " !$untrackedCount";
	}

	print BOLD, YELLOW, " ]", RESET;
}

exit 0;
