/*
Copyright (c) 2009 Victor Stanciu - http://www.victorstanciu.ro

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
*/

Carousel = Class.create(Abstract, {
	initialize: function (scroller, slides, controls, options) {
		this.scrolling	= false;
		this.scroller	= $(scroller);
		this.slides		= slides;
		this.controls	= controls;

		this.options    = Object.extend({
            duration:           1,
            auto:               false,
            frequency:          3,
            visibleSlides:      1,
            controlClassName:   'carousel-control',
            jumperClassName:    'carousel-jumper',
            disabledClassName:  'carousel-disabled',
            selectedClassName:  'carousel-selected',
            circular:           false,
            wheel:              true,
            effect:             'scroll',
            transition:         'sinoidal'
        }, options || {});

        if (this.options.effect == 'fade') {
            this.options.circular = true;
        }

		this.slides.each(function(slide, index) {
			slide._index = index;
        });

		if (this.controls) {
            this.controls.invoke('observe', 'click', this.click.bind(this));
        }

        if (this.options.wheel) {
            this.scroller.observe('mousewheel', this.wheel.bindAsEventListener(this)).observe('DOMMouseScroll', this.wheel.bindAsEventListener(this));;
        }

        if (this.options.auto) {
            this.start();
        }

		if (this.options.initial) {
			var initialIndex = this.slides.indexOf($(this.options.initial));
			if (initialIndex > (this.options.visibleSlides - 1) && this.options.visibleSlides > 1) {
				if (initialIndex > this.slides.length - (this.options.visibleSlides + 1)) {
					initialIndex = this.slides.length - this.options.visibleSlides;
				}
			}
            this.moveTo(this.slides[initialIndex]);
		}
	},

	click: function (event) {
		this.stop();

		var element = event.findElement('a');

		if (!element.hasClassName(this.options.disabledClassName)) {
			if (element.hasClassName(this.options.controlClassName)) {
				eval("this." + element.rel + "()");
            } else if (element.hasClassName(this.options.jumperClassName)) {
                this.moveTo(element.rel);
                if (this.options.selectedClassName) {
                    this.controls.invoke('removeClassName', this.options.selectedClassName);
                    element.addClassName(this.options.selectedClassName);
                }
            }
        }

		this.deactivateControls();

		event.stop();
    },

	moveTo: function (element) {
		if (this.options.beforeMove && (typeof this.options.beforeMove == 'function')) {
			this.options.beforeMove();
        }
		this.previous = this.current ? this.current : this.slides[0];
		this.current  = $(element);

		var scrollerOffset = this.scroller.cumulativeOffset();
		var elementOffset  = this.current.cumulativeOffset();

		if (this.scrolling) {
			this.scrolling.cancel();
		}

        switch (this.options.effect) {
            case 'fade':
                this.scrolling = new Effect.Opacity(this.scroller, {
                    from:   1.0,
                    to:     0,
                    duration: this.options.duration,
                    afterFinish: (function () {
                        this.scroller.scrollLeft = elementOffset[0] - scrollerOffset[0];
                        this.scroller.scrollTop  = elementOffset[1] - scrollerOffset[1];

                        new Effect.Opacity(this.scroller, {
                            from: 0,
                            to: 1.0,
                            duration: this.options.duration,
                            afterFinish: (function () {
                                if (this.controls) {
                                    this.activateControls();
                                }
                                if (this.options.afterMove && (typeof this.options.afterMove == 'function')) {
                                    this.options.afterMove();
                                }
                            }).bind(this)
                        });
                    }
                ).bind(this)});
            break;
            case 'scroll':
            default:
                var transition;
                switch (this.options.transition) {
                    case 'spring':
                        transition = Effect.Transitions.spring;
                        break;
                    case 'sinoidal':
                    default:
                        transition = Effect.Transitions.sinoidal;
                        break;
                }

                this.scrolling = new Effect.SmoothScroll(this.scroller, {
                    duration: this.options.duration,
                    x: (elementOffset[0] - scrollerOffset[0]),
                    y: (elementOffset[1] - scrollerOffset[1]),
                    transition: transition,
                    afterFinish: (function () {
                        if (this.controls) {
                            this.activateControls();
                        }
                        if (this.options.afterMove && (typeof this.options.afterMove == 'function')) {
                            this.options.afterMove();
                        }
                        this.scrolling = false;
                    }).bind(this)});
            break;
        }

		return false;
	},

	prev: function () {
		if (this.current) {
			var currentIndex = this.current._index;
			var prevIndex = (currentIndex == 0) ? (this.options.circular ? this.slides.length - 1 : 0) : currentIndex - 1;
        } else {
            var prevIndex = (this.options.circular ? this.slides.length - 1 : 0);
        }

		if (prevIndex == (this.slides.length - 1) && this.options.circular && this.options.effect != 'fade') {
			this.scroller.scrollLeft =  (this.slides.length - 1) * this.slides.first().getWidth();
			this.scroller.scrollTop =  (this.slides.length - 1) * this.slides.first().getHeight();
			prevIndex = this.slides.length - 2;
        }

		this.moveTo(this.slides[prevIndex]);
	},

	next: function () {
		if (this.current) {
			var currentIndex = this.current._index;
			var nextIndex = (this.slides.length - 1 == currentIndex) ? (this.options.circular ? 0 : currentIndex) : currentIndex + 1;
        } else {
            var nextIndex = 1;
        }

		if (nextIndex == 0 && this.options.circular && this.options.effect != 'fade') {
			this.scroller.scrollLeft = 0;
			this.scroller.scrollTop  = 0;
			nextIndex = 1;
    }

    var max = $('editor').getWidth() / 140 | 0;

    if (nextIndex == this.slides.length - (max - 1)) {
      new Ajax.Request('/admin/resources/get_thumbnails?position=' + this.slides.length,
        {
          method:'get',
          onSuccess: function(transport){
            var response = transport.responseText || "no response text";
            $('carousel-content').innerHTML += response;
            this.slides = $$('#carousel-content .slide');
            $('carousel-content').style.width = 140 * this.slides.length;
          }
        });
    }
		if (nextIndex > this.slides.length - (this.options.visibleSlides + 1)) {
			nextIndex = this.slides.length - this.options.visibleSlides;
		}

		this.moveTo(this.slides[nextIndex]);
	},

	first: function () {
		this.moveTo(this.slides[0]);
    },

	last: function () {
		this.moveTo(this.slides[this.slides.length - 1]);
    },

	toggle: function () {
		if (this.previous) {
			this.moveTo(this.slides[this.previous._index]);
        } else {
            return false;
        }
    },

	stop: function () {
		if (this.timer) {
			clearTimeout(this.timer);
		}
	},

	start: function () {
        this.periodicallyUpdate();
    },

	pause: function () {
		this.stop();
		this.activateControls();
    },

	resume: function (event) {
		if (event) {
			var related = event.relatedTarget || event.toElement;
			if (!related || (!this.slides.include(related) && !this.slides.any(function (slide) { return related.descendantOf(slide); }))) {
				this.start();
            }
        } else {
            this.start();
        }
    },

	periodicallyUpdate: function () {
		if (this.timer != null) {
			clearTimeout(this.timer);
			this.next();
        }
		this.timer = setTimeout(this.periodicallyUpdate.bind(this), this.options.frequency * 1000);
    },

    wheel: function (event) {
        event.cancelBubble = true;
        event.stop();

		var delta = 0;
		if (!event) {
            event = window.event;
        }
		if (event.wheelDelta) {
			delta = event.wheelDelta / 120;
		} else if (event.detail) {
            delta = -event.detail / 3;
        }

        if (!this.scrolling) {
            this.deactivateControls();
            if (delta > 0) {
                this.prev();
            } else {
                this.next();
            }
        }

		return Math.round(delta); //Safari Round
    },

	deactivateControls: function () {
		this.controls.invoke('addClassName', this.options.disabledClassName);
    },

	activateControls: function () {
		this.controls.invoke('removeClassName', this.options.disabledClassName);
    }
});


Effect.SmoothScroll = Class.create();
Object.extend(Object.extend(Effect.SmoothScroll.prototype, Effect.Base.prototype), {
	initialize: function (element) {
		this.element = $(element);
		var options = Object.extend({ x: 0, y: 0, mode: 'absolute' } , arguments[1] || {});
		this.start(options);
    },

	setup: function () {
		if (this.options.continuous && !this.element._ext) {
			this.element.cleanWhitespace();
			this.element._ext = true;
			this.element.appendChild(this.element.firstChild);
        }

		this.originalLeft = this.element.scrollLeft;
		this.originalTop  = this.element.scrollTop;

		if (this.options.mode == 'absolute') {
			this.options.x -= this.originalLeft;
			this.options.y -= this.originalTop;
        }
    },

	update: function (position) {
		this.element.scrollLeft = this.options.x * position + this.originalLeft;
		this.element.scrollTop  = this.options.y * position + this.originalTop;
    }
});