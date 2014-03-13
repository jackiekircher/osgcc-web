describe("handlers", function() {

  describe("warn", function() {

    it("prevents the action when confirm dialogue is false", function() {
      var element = $('#foo');
      var event   = spyOnEvent(element, 'click');

      spyOn(window, 'confirm').and.returnValue(false);
      element.click(handlers.warn);
      element.trigger("click");

      expect(event).toHaveBeenPrevented();
    });

    it("propagates action when confirm dialogue is true", function() {
      var element = $('#foo');
      var event   = spyOnEvent(element, 'click');

      spyOn(window, 'confirm').and.returnValue(true);
      element.click(handlers.warn);
      element.trigger("click");

      expect(event).toHaveBeenTriggered();
    });
  });
});

describe("warnIrreversible", function() {

  it("applies the warn handler to all .irreversible elements", function() {
    expect('.irreversible').toHandleWith('click', handlers.warn);
  });
});
