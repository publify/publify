/**
 * @author leon.li
 */
function setCssClass(obj, className) {
    if (Prototype.Browser.IE) {
		obj.className = className;
    } else {
		obj.setAttribute("class", className);
    }
}
function getCssClass(obj) {
    if (Prototype.Browser.IE) {
		return obj.className;
    } else {
		return obj.getAttribute("class");
    }
}
function showLoading(replace) {
	if (typeof(replace)!='undefined' && replace != null ) {
    	replace.innerHTML = $('loading').innerHTML;
    } else {
		Try.these(function() {setCssClass($('loading'), "showlayer")});
	}
}
function hideLoading(replace, backupHtml) {
	if (typeof(replace)!='undefined' && replace != null ) {
		replace.innerHTML = $('success').innerHTML;
		setTimeout(restoreFromBackup, 1000, replace, backupHtml);
    } else {
		Try.these(function() {setCssClass($('loading'), "hidelayer")});
	}
}
function restoreFromBackup(replace, backupHtml) {
	replace.innerHTML = backupHtml;
}
function ajaxPost(link, formObj, viewObj, decorator, success, replace) {
	if (link == "" || link == null) {
    	link = formObj.action;
    }
    var backupHtml = null;
    if (typeof(replace)!='undefined' && replace != null) {
    	backupHtml = replace.innerHTML;
    } else {
    	replace = "";
    }
    if (typeof(success)=='undefined' || success == null) {
    	success = "";
    }
    if (typeof(decorator)=='undefined' || decorator == null) {
    	decorator = "";
    } else {
    	decorator = "&decorator=" + decorator;
    }
    showLoading(replace);
    var realsuccess = function(){
    	hideLoading(replace,backupHtml);
    	success();
    }
    if (typeof(viewObj)!='undefined' && viewObj != null) {
		new Ajax.Updater(viewObj, link, {
                parameters: Form.serialize(formObj) + decorator,
                onComplete: realsuccess,
                evalScripts: true,
                method: "post",
                encoding: "UTF-8"
            })
	} else {
		new Ajax.Request(link, {
                parameters: Form.serialize(formObj),
                onComplete: realsuccess,
                evalScripts: true,
                method: "post",
                encoding: "UTF-8"
            })
	}
}
function ajaxLink(link, viewObj, decorator, success, replace) {
    if (link == "" || link == null) {
    	link = formObj.action;
    }
        var backupHtml = null;
    if (typeof(replace)!='undefined' && replace != null) {
    	backupHtml = replace.innerHTML;
    } else {
    	replace = "";
    }
    if (typeof(success)=='undefined' || success == null) {
    	success = "";
    }
    if (typeof(decorator)=='undefined' || decorator == null) {
    	decorator = "";
    } else {
    	decorator = {"decorator":decorator};
    }
    showLoading(replace);
    var realsuccess = function(){
    	hideLoading(replace,backupHtml);
    	success();
    }
	if (typeof(viewObj)!='undefined' && viewObj != null) {

		new Ajax.Updater(viewObj, link, {
     			parameters: decorator,
                onComplete: realsuccess,
                evalScripts: true,
                method: "get",
                encoding: "UTF-8"
            })
	} else {
		new Ajax.Request(link, {
                onComplete: realsuccess,
                evalScripts: true,
                method: "get",
                encoding: "UTF-8"
            })
	}
}