define(["jquery","DoughBaseComponent"],function(t,e){"use strict";var i=function(){i.baseConstructor.apply(this,arguments)};return e.extend(i),i.prototype.init=function(t){var e=this.$el.attr("title");this.$el.attr("data-tooltip",e).removeAttr("title"),this._initialisedSuccess(t)},i});