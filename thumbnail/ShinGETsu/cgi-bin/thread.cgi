#!/usr/bin/perl -w
#
# shinGETsu - P2P anonymous BBS
#
# (c) Fuktommy <fuktommy@users.sourceforge.net>
# Released under the GNU General Public License
# $Id: thread.cgi,v 1.1 2004/07/02 08:10:19 fuktommy Exp $
#
use strict;
use lib qw(..);
use Shingetsu::Config;
use Shingetsu::Cache;
use Shingetsu::CacheStat;
use Shingetsu::Gateway;

umask $Shingetsu::Config::umask;

my $datadir	= $Shingetsu::Config::datadir;
my $root	= $Shingetsu::Config::root;
my @types	= qw(list thread note);
my $message	= $Shingetsu::Gateway::message;

my $thumbonoff	= $Shingetsu::Config::thumbonoff;
my $thumburl    = $Shingetsu::Config::thumburl;
my $thumbdir    = $Shingetsu::Config::thumbdir;
my @thumbnail   = @Shingetsu::Config::thumbnail;
my $thumb_width = $Shingetsu::Config::thumb_width;

#
# print thread
#
sub printThread {
	my($thread) = @_;
	local $_;
	$thread = escape($thread);
	my $file_thread = file_encode("thread", $thread);
	touch($file_thread);
	open IN, "$datadir/$file_thread.dat" or die "$datadir/$file_thread.dat: failed to open. $!";
	printHeader($thread);
	print "<form method='get' action='$ENV{SCRIPT_NAME}'>",
	      "<p><input type='hidden' name='cmd' value='delete'  />",
	      "<input type='hidden' name='file' value='$file_thread'  /></p><dl>\n";
	my $count = 0;
	while (<IN>) {
		$count++;
		my %rec = rec($_);
		next if (keys %rec <= 2);
		my $xstamp = xlocaltime $rec{stamp};
		$rec{name} = $$message{anonymous} if ((! defined $rec{name}) || ($rec{name} eq ""));
		my $mail = "";
		$mail = "[$rec{mail}]" if (defined $rec{mail});
		$rec{body} = "" if (! defined $rec{body});
		$rec{body} = html_format($rec{body});
		if ($Shingetsu::Config::redirect) {
			$rec{body} =~ s|<a href='http://shingetsu\.p2p/|<a href='/|g;
		}
		my $attach = "";
		my $check  = "";
		my $remove = "";
		my $thumbnail = "";
		if ($rec{attach}) {
			my $size = int(length($rec{attach}) / 4 * 3 / 1024);
			$attach = " <a href='$ENV{SCRIPT_NAME}/" .
				  str_encode($thread) . "/$rec{id}/$rec{stamp}.$rec{suffix}'>" .
				  "$rec{stamp}.$rec{suffix}</a> (${size}$$message{kb})";
			if ($thumbonoff) {
				  $thumbnail = makeThumbnail($rec{id}, $rec{stamp}, $rec{suffix}, $rec{attach});
				  }
		}
		if ($rec{pubkey}) {
			$check = "<a href='$ENV{SCRIPT_NAME}?cmd=check&amp;" .
				 "file=" . file_encode("thread", $thread) . "&amp;" .
				 "stamp=$rec{stamp}&amp;id=$rec{id}'>" .
				 Shingetsu::Signature::pubkey2trip($rec{pubkey}) . "</a>";
		}
		if (($rec{remove_id}) && ($rec{remove_stamp})) {
			my $xid = substr($rec{remove_id},0,8);
			$remove = "[[$$message{remove}: <a href='#r$xid'>$xid</a>]]<br />";
		}
		my $xid = substr $rec{id}, 0, 8;
		print "<dt id='r$xid'><input type='radio' name='record' value='$rec{stamp}/$rec{id}' ",
		      "tabindex='1' accesskey='s' />",
		      "$xid <span class='name'>$rec{name}</span>",
		      " $mail $check $xstamp$attach</dt><dd>$thumbnail $rec{body}<br />$remove<br /></dd>\n";
	}
	close IN;
	print "</dl><p><input type='submit' value='$$message{del_record}' tabindex='2' accesskey='d' />",
      	      "<input type='hidden' name='mode' value='thread' /></p></form>";
	my $filesize = int((-s "$datadir/$file_thread.dat")/1024/1024*10)/10;
	my $checked = ($count)? "checked='checked'": "";
	my $readonly = ($ENV{REMOTE_ADDR} =~ $Shingetsu::Config::adminAddr)? "": "readonly='readonly'";
	if ($filesize <= $Shingetsu::Config::filelimit) {
		print "<form method='post' action='$ENV{SCRIPT_NAME}' enctype='multipart/form-data'><p>",
		"<input type='hidden' value='post' name='cmd' />",
		"<input type='hidden' value='$file_thread' name='file' />",
		"<input type='submit' value='$$message{post}' name='submit' tabindex='1' accesskey='w' />",
		" <input type='checkbox' value='dopost' name='dopost'",
		" $checked tabindex='2' accesskey='s' />",
		"$$message{send}",
		" <input type='checkbox' value='error' name='error'",
		" checked='checked' tabindex='2' accesskey='e' />",
		"$$message{error}<br />",
		" $$message{name}:<input name='name' size='15' value='' tabindex='3' accesskey='n' />",
		" $$message{mail}:<input name='mail' size='15' value='' tabindex='4' accesskey='m' />",
		" $$message{signature}:<input type='password' name='passwd' size='15' $readonly value='' tabindex='5' accesskey='p' /><br />",
		" $$message{attach}:<input type='file' name='attach' size='19' value='' tabindex='6' accesskey='a' />",
		" $$message{suffix}:<select name='suffix' size='1' tabindex='7'>",
		"<option>AUTO</option>";
		foreach (sort (keys %Shingetsu::Config::mimeType)) {
			print "<option>$_</option>";
		}
		print "</select> ($$message{limit}: ${Shingetsu::Config::filelimit}$$message{mb})<br />",
		"<textarea rows='5' cols='70' name='body' tabindex='8' accesskey='c'></textarea>",
		"</p></form>";
	}
	print "<form method='get' action='$ENV{SCRIPT_NAME}'>",
	      "<p><input type='submit' value='$$message{del_file}' tabindex='9' accesskey='d' />",
	      "<input type='hidden' name='cmd' value='delete' />",
	      "<input type='hidden' name='file' value='$file_thread' />",
	      " ${filesize}$$message{mb}</p></form></body></html>\n";
}

#
# print attachment
#
sub printAttach {
	my($thread, $id, $stamp, $suffix) = @_;
	$thread = file_encode("thread", escape($thread));
	my $ver = $Shingetsu::Config::version;
	$suffix = lc $suffix;
	my $type = $Shingetsu::Config::mimeType{$suffix};
	$type = "text/plain" unless (defined $type);
	touch($thread);
	open IN, "$datadir/$thread.dat" or die "$datadir/$thread.dat: failed to open. $!";
	my $value;
	while (<IN>) {
		my %rec = rec($_);
		if ($rec{attach} && ($rec{stamp} eq $stamp) && ($rec{id} eq $id)) {
			$value = $rec{attach};
			last;
		}
	}
	close IN;
	if (defined $value) {
		print "Content-Type: $type\r\n",
		      "X-Shingetsu: shinGETsu/$ver\r\n",
		      "\r\n",
		       Shingetsu::Extern::base64decode($value);
	} else {
		print404($thread);
	}
}

#
# make thumbnail
#
sub makeThumbnail { 
        my($tid, $tstamp, $tsuffix, $tattach) = @_;
        #dprint $tsuffix;
        foreach(@thumbnail){
                if ($tsuffix eq $_){
                       if ( -e "$thumbdir/thumbnail_$tid.$tstamp.$tsuffix" and -s "$thumbdir/thumbnail_$tid.$tstamp.$tsuffix") {
                       } else {
	                       open(OUT, "> $thumbdir/$tid.$tstamp.$tsuffix");
		               my $dec_attach = Shingetsu::Extern::base64decode($tattach);
		               print OUT "$dec_attach";
		               close(OUT);
		               system("convert -sample $thumb_width $thumbdir/$tid.$tstamp.$tsuffix $thumbdir/thumbnail_$tid.$tstamp.$tsuffix");
				unlink "$thumbdir/$tid.$tstamp.$tsuffix";
                       }
                       #$dec_attach = "";
                       return "<br><img src=\"$thumburl/thumbnail_$tid.$tstamp.$tsuffix\"><br>";
                }
        }
        #return "";
        #return "<br><img src=\"$thumburl/thumbnail_$tid.$tstamp.$tsuffix\"><br>";
}

#
# main routine
#
my ($path, $input) = readQuery();
my %arg;
if ((defined $ENV{CONTENT_TYPE}) && ($ENV{CONTENT_TYPE} =~ m|multipart/form-data|)) {
	%arg = argsFromMulti($input);
} else {
	%arg = args($input);
}

if ( -e $thumbdir and -d $thumbdir ){
}else{
        mkdir($thumbdir);
}

my $cmd = ($arg{cmd})? $arg{cmd}: "";
my $file = ($arg{file})? $arg{file}: "";
my $record = ($arg{record})? $arg{record}: "";

if (($cmd eq "post") && ($file =~ /^thread_[0-9A-F]+$/)) {
	my $id = post($file, %arg);
	print302("${root}thread.cgi/" . str_encode(file_decode($file)) . "#r$id");

} elsif ($cmd eq "check") {
	checkSign(%arg);

} elsif ($cmd eq "delete") {
	checkAdmin();
	deleteDialog(%arg);

} elsif ($cmd eq "xdelete") {
	checkAdmin();
	if (! defined $arg{file}) {
		print404();
		exit;
	} elsif ((defined $arg{stamp})&&(defined $arg{id})) {
		deleteRecord($arg{file}, $arg{stamp}, $arg{id}, \%arg);
	} else {
		deleteFile($arg{file});
	}

} elsif (($path ne "") && ($path !~ m|/|)) { 
	printThread($path);

} elsif ($path =~ m|^([^/]+)/([0-9a-f]{32})/(\d+)\.(.*)|) {
	my($file, $stamp, $id, $suffix) = ($1, $2, $3, $4);
	printAttach($file, $stamp, $id, $suffix);

} else {
	print404();
	exit;
}
