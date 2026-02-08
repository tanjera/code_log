#!/usr/bin/perl

use File::chdir;
use Cwd qw(abs_path);

$script_dir = `pwd`;
$proj_dir = abs_path("../");
$bundle_name = "app-release.aab";
$bundle_path = abs_path("../build/app/outputs/bundle/release/");
$rel_dir = abs_path("../release");

chdir($proj_dir) or die "$!";

system("flutter build appbundle");

if (-e "$rel_dir/$bundle_name") {
    print "Removing existing file at $rel_dir/$bundle_name\n";
    `rm $rel_dir/$bundle_name`;
}

system("mv $bundle_path/$bundle_name $rel_dir/$bundle_name");


print "File moved to $rel_dir/$bundle_name\n";