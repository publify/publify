// autocomplete and related changes 
// Copyright 2004 Leslie A. Hensley
// hensleyl@papermountain.org
// you have a license to do what ever you like with this code
// orginally from Avai Bryant 
// http://www.cincomsmalltalk.com/userblogs/avi/blogView?entry=3268075684

if (navigator.userAgent.indexOf("Safari") > 0)
{
  isSafari = true;
  isMoz = false;
  isIE = false;
}
else if (navigator.product == "Gecko")
{
  isSafari = false;
  isMoz = true;
  isIE = false;
}
else
{
  isSafari = false;
  isMoz = false;
  isIE = true;
}
    
function liveUpdaterUri(uri)
{
    return liveUpdater(function() { return uri; }, function () {});
}

function liveUpdater(uriFunc, postFunc)
{
    var request = false;
    var regex = /<(\w+).*?id="([\w-]+)".*?>((.|\n)*)<\/\1>/;
    
    if (window.XMLHttpRequest) {
        request = new XMLHttpRequest();
    }
    
    function update()
    {
        if(request && request.readyState < 4)
            request.abort();
            
        if(!window.XMLHttpRequest)
            request = new ActiveXObject("Microsoft.XMLHTTP");
        
        request.onreadystatechange = processRequestChange;
        request.open("GET", uriFunc());
        request.send(null);
        return false;
    }
    
    function processRequestChange()
    {
        if(request.readyState == 4)
        {
            var results = regex.exec(request.responseText);
            if(results)
            {
                document.getElementById(results[2]).innerHTML = results[3];
                postFunc();
            }
        }
    }

    return update;
}


function liveSearch(id, uri)
{
    function constructUri()
    {
        var separator = "?";
        if(uri.indexOf("?") >= 0)
            separator = "&";
        return uri + separator + "q=" + escape(document.getElementById(id).value);
    }
    
    var updater = liveUpdater(constructUri, function() {});
    var timeout = false;
        
    function start() {
     if (timeout)
         window.clearTimeout(timeout);
     
     timeout = window.setTimeout(updater, 300);
    }

  addKeyListener(document.getElementById(id), start); 
}

function autocomplete(id, popupId, uri)
{
    var inputField = document.getElementById(id);
    var popup = document.getElementById(popupId);
    var current = 0;
    function constructUri()
    {
        var separator = "?";
        if(uri.indexOf("?") >= 0)
            separator = "&";
        return uri + separator + "s=" + escape(inputField.value);
    }
    
    function handleClick(e)
    {
      inputField.value = eventElement(e).innerHTML;
      popup.style.visibility = 'hidden';
      inputField.focus();
    }
    
    function handleOver(e)
    {
      popup.firstChild.childNodes[current].className = '';
      current = eventElement(e).index;
      popup.firstChild.childNodes[current].className = 'selected';
    }
    
    function post()
    {
        current = 0;
        var options = popup.firstChild.childNodes;
        if((options.length > 1) || (options.length == 1 && options[0].innerHTML != inputField.value))
        {
          setPopupStyles();
          for(var i = 0; i < options.length; i++)
          {
            options[i].index = i;
            addOptionHandlers(options[i]);
          }
          options[0].className = 'selected';
        }
        else
        {
          popup.style.visibility = 'hidden';
        }
    }
  
    function setPopupStyles()
    {
      var maxHeight
      if(isIE)
      {
        maxHeight = 200;
      }
      else
      {
        maxHeight = window.outerHeight / 3;
      }
      if(popup.offsetHeight < maxHeight)
      {
        popup.style.overflow = 'hidden';
      }
      else if(isMoz)
      {
        popup.style.maxHeight = maxHeight + 'px';
        popup.style.overflow = '-moz-scrollbars-vertical';
      }
      else
      {
        popup.style.height = maxHeight + 'px';
        popup.style.overflowY = 'auto';
      }
      popup.scrollTop = 0;
      popup.style.visibility = 'visible';
    }
    
    function addOptionHandlers(option)
    {
      if(isMoz)
      {
        option.addEventListener("click", handleClick, false);
        option.addEventListener("mouseover", handleOver, false);
      }
      else
      {
        option.attachEvent("onclick", handleClick, false);
        option.attachEvent("onmouseover", handleOver, false);
      }
    }
    
    var updater = liveUpdater(constructUri, post);
    var timeout = false;
   
    function start(e) {
      if (timeout)
        window.clearTimeout(timeout);
      //up arrow
      if(e.keyCode == 38)
      {
        if(current > 0)
        {
          popup.firstChild.childNodes[current].className = '';
          current--;
          popup.firstChild.childNodes[current].className = 'selected';
          popup.firstChild.childNodes[current].scrollIntoView(true);
        }
      }
      //down arrow
      else if(e.keyCode == 40)
      {
        if(current < popup.firstChild.childNodes.length - 1)
        {
          popup.firstChild.childNodes[current].className = '';
          current++;
          popup.firstChild.childNodes[current].className = 'selected';
          popup.firstChild.childNodes[current].scrollIntoView(false);
        }
      }
      //enter or tab
      else if((e.keyCode == 13 || e.keyCode == 9) && popup.style.visibility == 'visible')
      {
        inputField.value = popup.firstChild.childNodes[current].innerHTML;
        popup.style.visibility = 'hidden';
        inputField.focus();
        if(isIE)
        {
          event.returnValue = false;
        }
        else
        {
          e.preventDefault();
        }
      }
      else
      {
        timeout = window.setTimeout(updater, 300);
      }
    }
  addKeyListener(inputField, start);
  addBlurListener(inputField, function() {popup.style.visibility = 'hidden';});
}

/* Functions to handle browser incompatibilites */
function eventElement(event)
{
  if(isMoz)
  {
    return event.currentTarget;
  }
  else
  {
    return event.srcElement;
  }
}

function addKeyListener(element, listener)
{
  if (isSafari)
    element.addEventListener("keydown",listener,false);
  else if (isMoz)
    element.addEventListener("keypress",listener,false);
  else
    element.attachEvent("onkeydown",listener);
}

function addBlurListener(element, listener)
{
  if(isIE)
    element.attachEvent("onblur",listener);
  else
    element.addEventListener("blur", listener, false);
}   
