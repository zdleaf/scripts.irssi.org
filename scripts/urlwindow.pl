#
# Print urls posted to channels or in /msg's to a window named "urls"
#
use strict;
use Irssi;
use POSIX;
use vars qw($VERSION %IRSSI); 

$VERSION = "1.1";
%IRSSI = (
    authors     => "zdleaf",
    contact     => 'leaf@zincldn.co.uk', 
    name        => "urlwindow",
    description => "Print urls to window named \"urls\"",
    license     => "Public Domain",
    url         => "http://irssi.org/",
);

my $window = Irssi::window_find_name('urls');

if (!$window){
	$window = Irssi::Windowitem::window_create('urls', 1);
	$window->set_name('urls');
}

sub sig_printtext {
    my ($dest, $text, $stripped) = @_;
    
    if(
        (($dest->{level} & (MSGLEVEL_PUBLIC)) || ($dest->{level} & (MSGLEVEL_MSGS))) && ($text =~ qr#((?:https?://[^\s<>"]+|www\.[-a-z0-9.]+)[^\s.,;<">\):])# ) 
		) 
		{
        $window = Irssi::window_find_name('urls');
        
        if ($dest->{level} & MSGLEVEL_PUBLIC) {
            $text = $dest->{target}.": ".$text;
        }
		
        $text = strftime(
            Irssi::settings_get_str('timestamp_format')." ",
            localtime
        ).$text;
        $window->print($text, MSGLEVEL_NEVER) if ($window);
    }
}


Irssi::signal_add('print text', 'sig_printtext');
