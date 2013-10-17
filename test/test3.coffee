html = '''
<!DOCTYPE HTML>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta name="cms_id" content="0029" />
<title>fdtemple</title>
</head>
<body>
<!--#include virtual="/special/banner13_top.html" -->
</body>
</html>

'''

console.log /meta name="cms_id" content="(\d{4})\S*"/.exec html

