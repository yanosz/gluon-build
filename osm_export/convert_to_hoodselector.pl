#!/usr/bin/perl -w 

my $ratio=100;

my $count = 0;

#  shapes = {
#    {
#      {
#        lat = 53.128,
#        lon = 8.187
#      },
#      {
#        lat = 53.163,
#        lon = 8.216
#      },
#    },
#  },
#,


print "  { \n";
while(<STDIN>){
	if(/<rtept lat="([0-9]*\.[0-9]+|[0-9]+)" lon="([0-9]*\.[0-9]+|[0-9]+)" \/>/){
		$count++;
		if ($count % $ratio == 0){
			print "    {\n      lat = $1,\n      long = $2\n    },\n";
		}	
	}
	
	
}
print "  },\n";
