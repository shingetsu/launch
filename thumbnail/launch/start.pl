#!perl

$dir1 = $ARGV[0];
$dir1 =~ s|:||;
$dir1 =~ s|\x5C|/|g;
$dir2 = $ARGV[0];
$dir2 =~ s|\x5C|/|g;
$ENV{'PATH'} = "/cygdrive/$dir1/perl/usr/bin:/cygdrive/$dir1/ImageMagick/usr/bin";
$ENV{'PERL5LIB'} = "/cygdrive/$dir1/perl/usr/lib/perl5/5.8.2";
$ENV{'thumburl'} = "file:///$dir2/ShinGETsu/thumbnail";
chdir "../ShinGETsu";
exec "../perl/usr/bin/perl httpd.pl";

#�Ƃقق�perl���� (http://tohoho.wakusei.ne.jp/wwwperl.htm) ���Q�l�ɂ����Ă��������܂����B