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
  pictitle:"宏光",
  price:"10.88",
  autoname:"宏光",
  serieslink:"http://product.auto.163.com/series/3368.html#0008B42"
};
var carpkObj={
  mincatename:"荣威550",
  maxcatename:"科鲁兹",
  minphotourl:"http://img4.cache.netease.com/photo/0008/2013-05-21/80x60_8VDRPD3U29NB0008.jpg",
  maxphotourl:"http://img3.cache.netease.com/photo/0008/2013-05-17/80x60_8V3A5V0L4V910008.jpg",
  minautoid:"2339",
  maxautoid:"2064"  
}
var priceoffObj={
  title:"[西安]别克凯越现金优惠1.8万元",
  link:"http://product.auto.163.com/series/3159.html",
  serieurl:"http://product.auto.163.com/series/3159.html",
  name:"科鲁兹",
  photourl:"http://img3.cache.netease.com/photo/0008/2013-05-10/120x90_8UHHPM2H29610008.png",
  pricearea:"14.9~24.9",
  priceareaurl:"http://product.auto.163.com/dealer/search/0_0_1752_3159_0_1.html#0008B12" 
};
module.exports = {
  getPriceInternal: function(){
    return {
      get: function(arg){
        return [priceObj,priceObj,priceObj,priceObj,priceObj,priceObj,priceObj,priceObj,priceObj,priceObj,priceObj,priceObj,priceObj,priceObj,priceObj,priceObj,priceObj,priceObj]
      }
    };
  },
  getBuyCar:function(){
    return [cardateObj,cardateObj,cardateObj,cardateObj]
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
  getFallPriceInfo:function(num){
    var arr = [];
    for(var i=0;i<num;i++){
      arr.push(priceoffObj);
    }
    return arr;
  }
}