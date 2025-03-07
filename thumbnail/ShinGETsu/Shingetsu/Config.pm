#
# shinGETsu - P2P anonymous BBS
#
# (c) FukTommy <fuktommy@users.sourceforge.net>
# Released under the GNU General Public License
# $Id: Config.pm,v 1.78 2004/08/09 13:07:28 fuktommy Exp $
#

package Shingetsu::Config;

$port		= 8000;
$debug		= 0;				# boolean
$resolv		= 0;				# boolean
$adminAddr	= "^127";			# regxp
$friendAddr	= ".";				# regxp
$path		= "/server.cgi";
$root		= "/";
$index		= "/gateway.cgi";
$cgiDir		= "./cgi-bin";
$css		= "/default.css";
$umask		= 0022;				# octet
@initNode	= qw(
	shingetsu.s45.xrea.com:80/index.cgi
	fuktommy.ddo.jp:8000/server.cgi
	yanga.s51.xrea.com:80/shingetsu/node.xcg
);

$menufile	= "menu";
$datadir	= "../dat";
$filedir	= "../file";
$motd		= "$filedir/motd.txt";
$nodelist	= "$datadir/node.txt";
$updatelist	= "$datadir/update.txt";
$lock		= "$datadir/lock.txt";
$pid		= "$datadir/pid.txt";
$client		= "$datadir/client.txt";
$stat		= "$datadir/stat.txt";
$trust		= "$datadir/trust.txt";

$thumbonoff	= 1;		# enable=1, disable=0
$thumburl       = $ENV{'thumburl'};
$thumbdir       = "../thumbnail";
@thumbnail      = qw(jpg gif png jpeg bmp);
$thumb_width    = 200;

$timeout	= 30;		# seconds
$timeout_client	= 30;		# minutes ( $timeout_client < $syncfrec )
$pingfrec	= 10;		# minutes
$syncfrec	= 60;		# minutes
$initfrec	= 25;		# minutes
$clientfrec	= 5;		# minutes
$syncsafety	= 240;		# hours
$saveupdate	= 1440;		# minutes
$timeError	= 60;		# seconds
$retry		= 5;		# times
$retrySearch	= 5;		# times
$childrenLimit	= 10;
$searchDepth	= 30;
$retryGet	= 3;		# times
$nodes		= 5;
$bufsize	= 8192;		# bytes
$filelimit	= 10;		# mega bytes
$redirect	= 1;		# boolean
$language	= "en";		# language code (see RFC3066)
$version	= "0.4.1";

$google		= "http://www.google.co.jp/search";

%command = (
	gzip	 => "gzip -c",
	gunzip	 => "gunzip -c",
	md5sum	 => "md5sum",
	uuencode => "uuencode -m",
	uudecode => "uudecode",
	apollo	 => "../contrib/apollo",
);

if ($^O eq "freebsd") {
	$command{md5sum}   = "md5";
	$command{uudecode} = "uudecode -p";
}

%mimeType = qw (
	avi	video/x-msvideo
	bin	application/octet-stream
	bmp	image/bmp
	cpio	application/x-cpio
	css	text/css
	csv	text/comma-separated-values
	dvi	application/x-dvi
	gif	image/gif
	html	text/html
	ico	image/x-icon
	jar	application/x-java-archive
	jpg	image/jpeg
	lzh	application/x-lzh
	mid	audio/midi
	mov	video/quicktime
	mp3	audio/mpeg
	mpg	video/mpeg
	ogg	application/x-ogg
	pdf	application/pdf
	pgp	application/pgp-signature
	png	image/png
	ps	application/postscript
	ra	audio/x-realaudio
	rpm	application/x-redhat-package-manager
	swf	application/x-shockwave-flash
	tar	application/x-tar
	tex	application/x-tex
	tif	image/tiff
	txt	text/plain
	tgz	application/x-gtar
	wav	audio/x-wav
	xml	text/xml
	zip	application/zip
);

1;
