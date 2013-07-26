#static-server
static-server是一个基于nodejs的本地前端开发环境，提供本地静态资源服务器和渲染vm模板的功能

##基本配置
```
\\config.json
{
  "port": 80,\\端口号，一般是80
  "dir": "d:/workspace/fontend",\\本地的前端文件目录
  "proxy": {\\如果在本地建立其他的域名也需要80端口，可以配置其他端口，在此次配置代理
    "www.youdomain.com": "http://127.0.0.1:8080"
  }
}
```
##hosts配置
```
127.0.0.1 dev.f2e.163.com
127.0.0.1 dev.f2e.netease.com
#如果配置了proxy，也需要将其host本绑定
127.0.0.1 www.youdomain.com
```

##运行
```
run.cmd
```