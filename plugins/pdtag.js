module.exports = {
  getPriceInternal: function(){
    return {
      get: function(arg){
        return []
      }
    };
  },
  getAutoSeriesInfoByID: function(arg){
    return {
      name: arg
    }
  },
  getCompareListByDate: function(){
    return {
      subList: function (){
        return [{},{},{}];
      }
    }
  }
}