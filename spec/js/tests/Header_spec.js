describe('Header', function() {

  'use strict';

  beforeEach(function(done) {
    var self = this;

    this.$sandbox = $('<div />').appendTo('body');

    requirejs(['componentLoader'], function(componentLoader) {
      self.componentLoader = componentLoader;

      self.beforeEachHook = function(done, fixtureHTML) {
        this.$sandbox.html(fixtureHTML || $(window.__html__['spec/js/fixtures/Header.html']).filter('#fixture-1').html());

        this.componentLoader.init(this.$sandbox)
          .then(function() {
            this.$filter = this.$sandbox.find('[data-dough-header-filter]');
            this.$header = this.$sandbox.children(0);
            done();
          }.bind(this));
      };
      done();
    });
  });

  afterEach(function() {
    this.$sandbox.empty();
  });

  describe('initial state after loading', function() {
    beforeEach(function(done) {
      this.beforeEachHook.call(this, done);
    });

    it('positions the filter div off screen', function() {
      expect(this.$filter).to.have.css('display', 'block');
      expect(this.$header).to.have.css('margin-top', '-100px');
    });
  });
});
