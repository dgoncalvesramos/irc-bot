use strict;
use warnings;
# On utilise la librairie Net::IRC pour se connecter à IRC
use Net::IRC ;
# On utilise la libraire Mime::Base64 pour décoder la chaine de caractère
use MIME::Base64;
# On utilise la libraire Compress::Zlib pour décompresser le message
use Compress::Zlib;

# Configuration des options de connexion (serveur, login) :
my $server = 'irc.root-me.org';
my $nick = 'perlBot_v1';
my $time = 0 ;

# Informations concernant le Bot :
my $ircname = 'irc.root-me.org';
my $username = 'perlBot';
my $version = '1.0';

# Channel sur lequel on veut que le Bot aille :
my $channel = '#root-me_challenge';

# On crée l'objet qui nous permet de nous connecter à IRC :
my $irc = new Net::IRC;

# On crée l'objet de connexion à IRC :
my $conn = $irc->newconn(
    'Server'      => $server,
    'Port'        => 6667, 
    'Nick'        => $nick,
    'Ircname'     => $ircname,
    'Username'    => $username
);

# On installe les fonctions de Hook :
$conn->add_handler('376', \&on_connect);         # Fin du MOTD => on est connecté
$conn->add_handler('msg', \&on_private); 	   # En privé 
 
 
 
# On lance la connexion et la boucle de gestion des événements :
$irc->start();


sub on_connect
{
    my ($conn, $event) = @_;
    
    $conn->join($channel);
    $conn->privmsg('Candy', '!ep4');
    $conn->{'connected'} = 1;
} # Fin on_connect


sub on_private
{
    my ($conn, $event) = @_;
    my $text = $event->{'args'}[0];
    if($time == 0)
    {
        my $response = uncompress(decode_base64($text));
    	$conn->privmsg('Candy', "!ep4 -rep $response");
    }
    else
    {
       $conn->print("PRIVE<" . $event->nick() . ">\t| $text");
    }
    $time++;    
} # Fin on_private

