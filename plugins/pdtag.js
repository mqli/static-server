var priceObj = {
       hot_src:"http://img4.cache.netease.com/photo/0008/2013-05-21/120x90_8VDRPD3U29NB0008.jpg",
       original_name:"荣威550",
       serieurl:"http://product.auto.163.com/series/2339.html#0008B00"
};
var cardateObj ={
	time:"7月26日",
	pricelink:"http://product.auto.163.com/series/3368.html#0008B42",
	name:"宏光",
	seriesname:"宏光",
	pic_src:"http://img4.cache.netease.com/stock/2012/10/30/2012103010122251732.jpg",
	pictitle:"宏光",
	price:"10.88",
	autoname:"宏光",
	serieslink:"http://product.auto.163.com/series/3368.html#0008B42"
};
var carpkObj={
	mincatename:"荣威550",
	maxcatename:"科鲁兹",
	minphotourl:"http://img3.cache.netease.com/photo/0008/2013-05-10/120x90_8UHHPM2H29610008.png",
	maxphotourl:"http://img3.cache.netease.com/photo/0008/2013-05-10/120x90_8UHHPM2H29610008.png",
	minautoid:"2339",
	maxautoid:"2064"	
}
var priceoffObj={
	title:"[西安]别克凯越优惠1.8万元",
	url:"http://product.auto.163.com/series/3159.html",
	serieurl:"http://product.auto.163.com/series/3159.html",
	name:"科鲁兹",
	photourl:"http://img4.cache.netease.com/photo/0008/2013-03-12/80x60_8POQC9J6296P0008.jpg",
	pricearea:"14.9~24.9",
	priceareaurl:"http://product.auto.163.com/dealer/search/0_0_1752_3159_0_1.html"	
}

var rankObj={
	lowprice:"9.48",
	highprice:"12.78",
	name:"翼搏",
	link:"/series/16801.html"
}
var videoObj={
	pageurl:"http://v.auto.163.com/video/2013/8/V/S/V94J8SHVS.html",
	imgpath:"http://vimg3.ws.126.net/image/snapshot/2013/8/V/T/V94J8SHVT",
	title:"全新宝马5系550i"
}


module.exports = {
  getPriceInternal: function(){
    return {
      get: function(arg){
        return [priceObj,priceObj,priceObj,priceObj,priceObj,priceObj,priceObj,priceObj,priceObj,priceObj,priceObj,priceObj,priceObj,priceObj,priceObj,priceObj,priceObj,priceObj]
      }
    };
  },
  getBuyCar:function(){
  	return [cardateObj,cardateObj,cardateObj,cardateObj,cardateObj]
  },
  getAutoSeriesInfoByID: function(arg){
    return {
      name: arg
    }
  },
  getCompareListByDate: function(){
    return {
      subList: function (){
        return [carpkObj,carpkObj,carpkObj,carpkObj,carpkObj];
      }
    }
  },
  getRankByType:function(type,flag,num){
  	var arr=[];
  	for(var i=0;i<num;i++){
  		arr.push(rankObj);
  	}  	
    return arr;	
  },
  getFallPriceInfo:function(num){
  	var arr = [];
  	for(var i=0;i<num;i++){
  		arr.push(priceoffObj);
  	}
  	return arr;
  },
  getVideoLibWebService:function(){
  	return this;
  },
  getAllVideoBySid:function(id,num1,num2,num3){
  	var arr = [];
  	for(var i=0;i<num3;i++){
  		arr.push(videoObj);
  	}
  	return arr;
  }  
}