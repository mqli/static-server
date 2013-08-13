var mocking = require('../lib/mocking');
module.exports = {
  getCmsDataSource: function(method, params) {
    return mocking.array(mocking.object({
      rcount: 0,
      clickCount:0,
      realReplyCount:0,
      postId: mocking.inc(1),
      postTitle: mocking.string(mocking.int(10, 20), "标题"),
    }), params.count || 2)();
  }
};