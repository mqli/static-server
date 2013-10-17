methods =
  BeijingtTimeZone: 'String',
  changePicSize: 'String',
  commentCheckedCount: 'Number',
  commentCount: 'Number',
  commentNum: 'Number',
  commentNumIncludingCombined: 'Number',
  commentPCount: 'Number',
  cutImg: 'String',
  cutMixTitle: 'String',
  cutOneTitle: 'String',
  cutString: 'String',
  cutTags: 'String',
  cutTitle: 'String',
  cutHtmlString: 'String',
  cyclical: 'String',
  cyclicald: 'String',
  cyclicalm: 'String',
  d2i: 'Number',
  decodeString: 'String',
  diggCount: 'Number',
  docidFromURL: 'String',
  encodeString: 'String',
  filterKeyword: 'String',
  formatLong: 'String',
  getAllRealContent: 'String',
  getArticleBoard: 'String',
  getBody: 'String',
  getBrief: 'String',
  getBuloid: 'String',
  getCindexProperty: 'String',
  getCommentBBSUrl: 'String',
  getDate: 'String',
  getDateAfter: 'String',
  getDaynum: 'Number',
  getDigest: 'String',
  getDiggCount: 'Number',
  getdomain: 'String',
  getFirstPic: 'String',
  getGMTimeZone: 'String',
  getIntValue: 'Number',
  getJoinCount: 'Number',
  getKeyString: 'String',
  getLength: 'Number',
  getLocalname: 'String',
  getLongValue: 'Number',
  getMobileUrl: 'String',
  getNongli: 'String',
  getPhotoBigImgsrc: 'String',
  getProperty: 'String',#返回第二个参数的字段
  getRealContentJson: 'String',
  getReplacedBody: 'String',
  getSource: 'String',
  getTime: 'String',
  getTopicCount: 'Number',
  getWebConent: 'String',
  getWeekday: 'String',
  getYasoUrl: 'String',
  icon: 'String',
  IndexOf: 'Number',
  join: 'String',
  LondonTimeZone: 'String',
  parse: 'String',
  ParseTime: 'String',
  parseTimeToMillisecond: 'Number',
  parseTimeToSecond: 'Number',
  plus: 'Number',
  replaceAll: 'String',
  replUrlByShort: 'String',
  ruship: 'String',
  setImageForYaso: 'String',
  urlencode: 'String'
  stripTags:'String'
module.exports = {}

Object.keys(methods).forEach (name)->
  type = methods[name]
  module.exports[name] = (arg)->
    console.log name, type
    if type == 'Number' then 1 else arg or ''
  module.exports.createMap = ()-> {}
  module.exports.isFine = ()-> true
  module.exports.subString =  (arg)-> arg
  module.exports.getFirstPic = (arg)-> 'http://img4.cache.netease.com/stock/2012/10/30/2012103010122251732.jpg'