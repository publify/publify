<?PHP

include "../index.php";

$shell['title3'] = "Debounce";

$shell['h2'] = 'Don\'t fire that event any more than you have to!';

// ========================================================================== //
// SCRIPT
// ========================================================================== //

ob_start();
?>
$(function(){
  
  var default_text = $('#text-type').text(),
      text_counter_1 = 0,
      text_counter_2 = 0;
  
  // This function is not debounced, but instead bound directly to the event.
  function text_1() {
    var val = $(this).val(),
      html = 'Not-debounced AJAX request executed: ' + text_counter_1++ + ' times.'
      + ( val ? ' Text: ' + val : '' );
    
    $('#text-type-1').html( html );
  };
  
  // This function is debounced, and the new, debounced, function is bound to
  // the event. Note that in jQuery 1.4+ a reference to either the original or
  // debounced function can be passed to .unbind to unbind the function.
  function text_2() {
    var val = $(this).val(),
      html = 'Debounced AJAX request executed: ' + text_counter_2++ + ' times.'
      + ( val ? ' Text: ' + val : '' );
    
    $('#text-type-2').html( html );
  };
  
  // Bind the not-at-all debounced handler to the keyup event.
  $('input.text').keyup( text_1 );
  
  // Bind the debounced handler to the keyup event.
  $('input.text').keyup( $.debounce( 250, text_2 ) ); // This is the line you want!
  
  // Trigger the callbacks once to show some initial (zero) values.
  text_1();
  text_2();
});
<?
$shell['script'] = ob_get_contents();
ob_end_clean();

// ========================================================================== //
// HTML HEAD ADDITIONAL
// ========================================================================== //

ob_start();
?>
<script type="text/javascript" src="../../jquery.ba-throttle-debounce.js"></script>
<script type="text/javascript" language="javascript">

<?= $shell['script']; ?>

$(function(){
  
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

input.text {
  width: 20em;
  border: 1px solid #000;
  padding: 0.3em;
  font-size: 120%;
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
  Using <a href="http://benalman.com/projects/jquery-throttle-debounce-plugin/">jQuery throttle / debounce</a>, you can pass a delay and function to <code>$.debounce</code> to get a new function, that when called repetitively, executes the original function just once per "bunch" of calls.
</p>
<p>
  This can be especially useful for rate limiting execution of handlers on events that will trigger AJAX requests. Just take a look at this example to see for yourself!
</p>

<h3>Typing into a textfield</h3>
<p>Give this "pretend autocomplete" field a try. After typing a sentence you'll see why debouncing is a good idea!</p>
<form action="" method="get">
  <input class="text" type="text" name="whatever">
</form>

<h3>The real-world simulation</h3>
<p id="text-type-1"></p>
<p id="text-type-2"></p>

<p>
  <em>(No, there is no actual AJAX request happening here, but if there was, that not-debounced version would be killing your server)</em>
</p>

<h3>The code</h3>
<div class="clear"></div>
<pre class="brush:js">
<?= htmlspecialchars( $shell['script'] ); ?>
</pre>

<?
$shell['html_body'] = ob_get_contents();
ob_end_clean();

// ========================================================================== //
// DRAW SHELL
// ========================================================================== //

draw_shell();

?>
