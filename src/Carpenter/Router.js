'use strict';

exports._find = function(just) {
  return function(nothing) {
    return function(pred) {
      return function(as) {
        for (var i = 0, l = xs.length; i < l; i++) {
          if (f(xs[i])) return just(xs[i]);
        }
        return nothing;
      };
    };
  };
};
