<?PHP

$shell['title1'] = "jQuery throttle / debounce";
$shell['link1']  = "http://benalman.com/projects/jquery-throttle-debounce-plugin/";

ob_start();
?>
  <a href="http://benalman.com/projects/jquery-throttle-debounce-plugin/">Project Home</a>,
  <a href="http://benalman.com/code/projects/jquery-throttle-debounce/docs/">Documentation</a>,
  <a href="http://github.com/cowboy/jquery-throttle-debounce/">Source</a>
<?
$shell['h3'] = ob_get_contents();
ob_end_clean();

$shell['jquery'] = 'jquery-1.4.2.js';
//$shell['jquery'] = 'jquery-1.3.2.js';

$shell['shBrush'] = array( 'JScript' );

?>
