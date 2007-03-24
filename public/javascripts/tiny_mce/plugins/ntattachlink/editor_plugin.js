tinyMCE.importPluginLanguagePack("ntattachlink","en,tr,de,sv,zh_cn,cs,fa,fr_ca,fr,pl,pt_br,nl,he,nb,ru,ru_KOI8-R,ru_UTF-8,nn,cy,es,is,zh_tw,zh_tw_utf8,sk,da");
var TinyMCE_NTAttachLinkPlugin={getInfo:function(){
return {longname:"Near-Time Attach Linker",author:"Blake Watters",authorurl:"http://thatswhatimtalkingabout.org/",infourl:"http://www.near-time.net/",version:tinyMCE.majorVersion+"."+tinyMCE.minorVersion};
},getControlHTML:function(cn){
switch(cn){
case "ntattachlink":
return tinyMCE.getButtonHTML(cn,"lang_attach_desc","{$themeurl}/images/attach.gif","mceNearTimeAttachLink");
}
return "";
},execCommand:function(_2,_3,_4,_5,_6){
switch(_4){
case "mceNearTimeAttachLink":
Element.hide("formatbar_image");
Element.hide("formatbar_link");
Element.toggleWithHighlight("formatbar_attach");
return true;
}
return false;
},handleNodeChange:function(_7,_8,_9,_a,_b,_c){
if(_8==null){
return;
}
do{
if(_8.nodeName=="A"&&tinyMCE.getAttrib(_8,"href")!=""){
tinyMCE.switchClass(_7+"_advlink","mceButtonSelected");
return true;
}
}while((_8=_8.parentNode));
if(_c){
tinyMCE.switchClass(_7+"_Attachlinker","mceButtonNormal");
return true;
}
tinyMCE.switchClass(_7+"_Attachlinker","mceButtonDisabled");
return true;
}};
tinyMCE.addPlugin("ntattachlink",TinyMCE_NTAttachLinkPlugin);

