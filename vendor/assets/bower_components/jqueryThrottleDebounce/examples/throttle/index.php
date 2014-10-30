<?PHP

include "../index.php";

$shell['title3'] = "Throttle";

$shell['h2'] = 'Don\'t fire that event any more than you have to!';

// ========================================================================== //
// SCRIPT
// ========================================================================== //

ob_start();
?>
$(function(){
  
  var counter_1 = 0,
      counter_2 = 0
      last_time_1 = +new Date(),
      last_time_2 = +new Date();
  
  // This function is not throttled, but instead bound directly to the event.
  function resize_1() {
    var now = +new Date(),
      html = 'resize handler executed: ' + counter_1++ + ' times'
      + ' (' + ( now - last_time_1 ) + 'ms since previous execution)'
        + '<br/>window dimensions: ' + $(window).width() + 'x' + $(window).height();
    
    last_time_1 = now;
    
    $('#text-resize-1').html( html );
  };
  
  // This function is throttled, and the new, throttled, function is bound to
  // the event. Note that in jQuery 1.4+ a reference to either the original or
  // throttled function can be passed to .unbind to unbind the function.
  function resize_2() {
    var now = +new Date(),
      html = 'throttled resize handler executed: ' + counter_2++ + ' times'
        + ' (' + ( now - last_time_2 ) + 'ms since previous execution)'
        + '<br/>window dimensions: ' + $(window).width() + 'x' + $(window).height();
    
    last_time_2 = now;
    
    $('#text-resize-2').html( html );
  };
  
  // Bind the not-at-all throttled handler to the resize event.
  $(window).resize( resize_1 );
  
  // Bind the throttled handler to the resize event.
  $(window).resize( $.throttle( 250, resize_2 ) ); // This is the line you want!
  
});
<?
$shell['script1'] = ob_get_contents();
ob_end_clean();

ob_start();
?>
$(function(){
  
  var counter_1 = 0,
      counter_2 = 0
      last_time_1 = +new Date(),
      last_time_2 = +new Date();
  
  // This function is not throttled, but instead bound directly to the event.
  function scroll_1() {
    var now = +new Date(),
      html = 'scroll handler executed: ' + counter_1++ + ' times'
        + ' (' + ( now - last_time_1 ) + 'ms since previous execution)'
        + '<br/>window scrollLeft: ' + $(window).scrollLeft() + ', scrollTop: ' + $(window).scrollTop();
    
    last_time_1 = now;
    
    $('#text-scroll-1').html( html );
  };
  
  // This function is throttled, and the new, throttled, function is bound to
  // the event. Note that in jQuery 1.4+ a reference to either the original or
  // throttled function can be passed to .unbind to unbind the function.
  function scroll_2() {
    var now = +new Date(),
      html = 'throttled scroll handler executed: ' + counter_2++ + ' times'
        + ' (' + ( now - last_time_2 ) + 'ms since previous execution)'
        + '<br/>window scrollLeft: ' + $(window).scrollLeft() + ', scrollTop: ' + $(window).scrollTop();
    
    last_time_2 = now;
    
    $('#text-scroll-2').html( html );
  };
  
  // Bind the not-at-all throttled handler to the scroll event.
  $(window).scroll( scroll_1 );
  
  // Bind the throttled handler to the scroll event.
  $(window).scroll( $.throttle( 250, scroll_2 ) ); // This is the line you want!
  
});
<?
$shell['script2'] = ob_get_contents();
ob_end_clean();

// ========================================================================== //
// HTML HEAD ADDITIONAL
// ========================================================================== //

ob_start();
?>
<script type="text/javascript" src="../../jquery.ba-throttle-debounce.js"></script>
<script type="text/javascript" language="javascript">

<?= $shell['script1']; ?>

<?= $shell['script2']; ?>

$(function(){
  
  // Trigger these events once to show some initial (zero) values.
  $(window).resize().scroll();
  
  // Syntax highlighter.
  SyntaxHighlighter.highlight();
  
});

</script>
<style type="text/css" title="text/css">

/*
bg: #FDEBDC
bg1: #FFD6AF
bg2: #FFAB59
orange: #FF7F00
brown: #913D00
lt. brown: #C4884F
*/

#page {
  width: 700px;
}


</style>
<?
$shell['html_head'] = ob_get_contents();
ob_end_clean();

// ========================================================================== //
// HTML BODY
// ========================================================================== //

ob_start();
?>
<?= $shell['donate'] ?>

<p>
  Using <a href="http://benalman.com/projects/jquery-throttle-debounce-plugin/">jQuery throttle / debounce</a>, you can pass a delay and function to <code>$.throttle</code> to get a new function, that when called repetitively, executes the original function (in the same context and with all arguments passed through) no more than once every delay milliseconds.
</p>
<p>
  This can be especially useful for rate limiting execution of handlers on events like resize and scroll. Just take a look at the examples to see for yourself!
</p>

<h3>Window resize (some browsers fire this event continually)</h3>
<p id="text-resize-1"></p>
<p id="text-resize-2"></p>

<h3>The code</h3>
<div class="clear"></div>
<pre class="brush:js">
<?= htmlspecialchars( $shell['script1'] ); ?>
</pre>

<h3>Window scroll (some browsers fire this event continually)</h3>
<p id="text-scroll-1"></p>
<p id="text-scroll-2"></p>

<h3>The code</h3>
<pre class="brush:js">
<?= htmlspecialchars( $shell['script2'] ); ?>
</pre>



<?
$shell['html_body'] = ob_get_contents();
ob_end_clean();

// ========================================================================== //
// DRAW SHELL
// ========================================================================== //

draw_shell();

?>
