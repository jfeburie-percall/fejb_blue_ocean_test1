#####################################################################################
# This program will change the FileVersion and FILEVERSION accordingly and set them
# consistently across all the directories.
#
# To use this program, run as
#         IncVersion.pl folder project-1 version build
#
#####################################################################################

# print "folder      = ".$ARGV[0]."\n";
# print "project     = ".$ARGV[1]."\n";
# print "version     = ".$ARGV[2]."\n";
# print "build       = ".$ARGV[3]."\n";

$project_ver=$ARGV[2];
$BUILD_NB=$ARGV[3];
$project_ver =~ s/\./,/g;
# print "new version = ".$project_ver."\n";

$file1 = $ARGV[0]."\\".$ARGV[1].".rc";
$file2 = $ARGV[0]."\\".$ARGV[1].".tmp";
eval { ProcessFile()};
if ($@) {
	print $@;
} else {
	eval { CopyFile()};
	print $@;
}
 
 
 
 
sub ProcessFile {
# print "Converting $file1 to $file2\n";
	open(InRC, "$file1") || die "Failed to open $file1 to read\n\t$!\n";
	open(OutRC, ">$file2") || die "Failed to open $file2 to write\n\t$!\n";
	while ($_ = <InRC>)  {
		if ($_ =~/FILEVERSION/) {
			print OutRC " FILEVERSION ".$project_ver."\n";
		} 
		elsif ($_ =~/PRODUCTVERSION/) {
			print OutRC " PRODUCTVERSION ".$project_ver."\n";
		} 
		elsif ($_ =~/PrivateBuild/) {
			#print OutRC " PrivateBuild $BUILD_NB\n";
		} 
		elsif ($_  =~/FileVersion/) {
			print OutRC "            VALUE \"FileVersion\", \"".$project_ver."\"\n";
			print OutRC "            VALUE \"PrivateBuild\", \"Build : ".$BUILD_NB."\"\n";
		}
		elsif ($_ =~/ProductVersion/) {
			print OutRC "            VALUE \"ProductVersion\", \"".$project_ver."\"\n";
		}
		else {
			# Print the line "as is"
			print OutRC "$_";
		}
	}
	close (InRC);
	close (outRC);
	print $ARGV[1].".rc updated\n";
}
 
sub CopyFile {
	# print "Copying $file2 to $file1\n";
	unlink($file1);
	open(InRC, "$file2") || die "Failed to open $file2 to read\n\t$!\n";
	open(OutRC, ">$file1") || die "Failed to open $file1 to write\n\t$!\n";
	while ($_ = <InRC>)  {
		print OutRC "$_";
	}
	close (InRC);
	close (outRC);
}

