'use strict';

exports._find = function(just) {
  return function(nothing) {
    return function(pred) {
      return function(as) {
        for (var i = 0, l = as.length; i < l; i++) {
          if (pred(as[i])) return just(as[i]);
        }
        return nothing;
      };
    };
  };
};
