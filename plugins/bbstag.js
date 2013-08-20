var mocking = require('../lib/mocking');
var bbsObj ={
      postTitle: "日产新天籁是不是前大灯，会自动转弯调节",
      threadId:"100012586322",
      postContent: 	"我也不知道，坐等答案吧~"
};
var bbsBoardObj ={
      boardUrl: "fengxing",
      boardName:"奔驰车友会"
};
module.exports = {
  getCmsDataSource: function(method, params) {
  	if(method=="getCheyoubangPosts"){
  		return [{thread:bbsObj,replyPost:bbsObj}];
  	}
  	
  	if(method=="getBoardsPublishMost"){
  		var arr = [];
  		var num = params.count||14;
  		for(var i = 0;i<num;i++){
  			arr.push(bbsBoardObj);
  		}
  		return arr;
  	}  	

    return mocking.array(mocking.object({
      rcount: 0,
      clickCount:0,
      realReplyCount:0,
      postId: mocking.inc(1),
      postTitle: mocking.string(mocking.int(10, 20), "标题"),
    }), params.count || 2)();  		  	
  }
};

