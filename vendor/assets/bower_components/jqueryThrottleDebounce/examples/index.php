<?PHP

$shell = array();
$base = '../';

$shell['title2'] = 'Examples';
$shell['link2'] = '../';

include 'config.php';

ob_start();
?>
    <div id="donate">
      <p>Your generous donation allows me to continue developing and updating my code!</p>
      <form action="https://www.paypal.com/cgi-bin/webscr" method="post">
      <input type="hidden" name="cmd" value="_s-xclick">
      <input type="hidden" name="hosted_button_id" value="5791421">
      <input class="submit" type="image" src="../donate.gif" name="submit" alt="PayPal - The safer, easier way to pay online!">
      <img alt="" border="0" src="https://www.paypal.com/en_US/i/scr/pixel.gif" width="1" height="1">
      </form>
      <div class="clear"></div>
    </div>
<?
$shell['donate'] = ob_get_contents();
ob_end_clean();

function draw_shell() {
  global $shell, $base;
  
?><!DOCTYPE html>
<html lang="en">
<head>
  <meta http-equiv="content-type" content="text/html; charset=utf-8">
  <title>Ben Alman &raquo; <?= $shell['title1'] ?><? if ( $shell['title2'] ) { print ' &raquo; ' . $shell['title2']; } ?><? if ( $shell['title3'] ) { print ' &raquo; ' . $shell['title3']; } ?></title>
  <script type="text/javascript" src="<?= $base ?>../shared/ba-debug.js"></script>
  <?
  if ( $shell['jquery'] ) {
    ?><script type="text/javascript" src="<?= $base ?>../shared/<?= $shell['jquery'] ?>"></script><?
  }
  
  ?><script type="text/javascript" src="<?= $base ?>../shared/SyntaxHighlighter/scripts/shCore.js"></script><?
  
  if ( $shell['shBrush'] ) {
    foreach ( $shell['shBrush'] as $brush ) {
      ?><script type="text/javascript" src="<?= $base ?>../shared/SyntaxHighlighter/scripts/shBrush<?= $brush ?>.js"></script><?
    }
  }
  ?>
  <link rel="stylesheet" type="text/css" href="<?= $base ?>../shared/SyntaxHighlighter/styles/shCore.css">
  <link rel="stylesheet" type="text/css" href="<?= $base ?>../shared/SyntaxHighlighter/styles/shThemeDefault.css">
  <link rel="stylesheet" type="text/css" href="<?= $base ?>index.css">
  
<?= $shell['html_head'] ?>

</head>
<body>

<div id="page">
  <div id="header">
    <h1>
      <a href="http://benalman.com/" class="title"><b>Ben</b> Alman</a>
      <?
      $i = 1;
      while ( $shell["title$i"] ) {
        print ' &raquo; ';
        if ( $shell["link$i"] ) {
          print '<a href="' . $shell["link$i"] . '">' . $shell["title$i"] . '</a>';
        } else {
          print $shell["title$i"];
        }
        $i++;
      }
      ?>
    </h1>
    <?
    $i = 2;
    while ( $shell["h$i"] ) {
      print "<h$i>" . $shell["h$i"] . "</h$i>";
      $i++;
    }
    ?>
    <?= $shell['html_header'] ?>
  </div>
  <div id="content">
    <?= $shell['html_body'] ?>
  </div>
  <div id="footer">
    <p>
      If console output is mentioned, but your browser has no console, this example is using <a href="http://benalman.com/projects/javascript-debug-console-log/">JavaScript Debug</a>. Click this bookmarklet: <a href="javascript:if(!window.firebug){window.firebug=document.createElement(&quot;script&quot;);firebug.setAttribute(&quot;src&quot;,&quot;http://getfirebug.com/releases/lite/1.2/firebug-lite-compressed.js&quot;);document.body.appendChild(firebug);(function(){if(window.firebug.version){firebug.init()}else{setTimeout(arguments.callee)}})();void (firebug);if(window.debug&&debug.setCallback){(function(){if(window.firebug&&window.firebug.version){debug.setCallback(function(b){var a=Array.prototype.slice.call(arguments,1);firebug.d.console.cmd[b].apply(window,a)},true)}else{setTimeout(arguments.callee,100)}})()}};">Debug + Firebug Lite</a> to add the Firebug lite console to the current page. Syntax highlighting is handled by <a href="http://alexgorbatchev.com/">SyntaxHighlighter</a>.
    </p>
    <p>
      All original code is Copyright &copy; 2010 "Cowboy" Ben Alman and dual licensed under the MIT and GPL licenses. View the <a href="http://benalman.com/about/license/">license page</a> for more details. 
    </p>
  </div>
</div>

</body>
</html><?

}

if ( count( get_included_files() ) == 2 ) {
  $shell['link2'] = '';
  
  $shell['h2'] = 'Select an example:';
  $shell['h3'] = '';
  
  $shell['html_body'] = '';
  
  $files = scandir( '.' );
  foreach ( $files as $file ) {
    if ( $file != '.' && $file != '..' && file_exists( "$file/index.php" ) ) {
      $file_contents = file_get_contents( "$file/index.php" );
      $title = preg_replace( '/^.*\$shell\[\'title3\'\]\s*=\s*"(.*?)";.*$/s', '$1', $file_contents );
      $title = $title == $file_contents ? $file : stripcslashes( $title );
      $shell['html_body'] .= "<a href=\"$file/\">$title</a><br>";
    }
  }
  
  $base = '';
  draw_shell();
}

?>
