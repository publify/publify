function htmlEncode(text) {
	if (!text)
		return '' ;
	text = text.replace(/&/g, '&amp;');
	text = text.replace(/</g, '&lt;');
	text = text.replace(/>/g, '&gt;');
	return text ;
}
function translateTag(tag, propertyToSet, encode) {
	var tags = document.getElementsByTagName(tag) ;
	var sKey, s ;
	for (var i = 0 ; i < tags.length ; i++ ) {
		if ((sKey = tags[i].getAttribute( 'fmLang' ))) {
			if ((s = FMLang[sKey]) && s.length > 0)	{
				if (encode) {
					s = htmlEncode(s);
				}
				tags[i][ propertyToSet ] = s ;

			}
		}
	}
}
function translatePage() {
	translateTag('INPUT', 'value');
	translateTag('SPAN', 'innerHTML');
	translateTag('LABEL', 'innerHTML');
	translateTag('OPTION', 'innerHTML', true);
	translateTag('LEGEND', 'innerHTML');
}

function getText(key, defaultValue) {
	if (!FMLang[key]) {
		if (!defaultValue) {
			return key;
		} else {
			return defaultValue;
		}
	} else {
		return FMLang[key];
	}
}
