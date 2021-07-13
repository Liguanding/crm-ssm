1 在用户登录的时候,controller层能否通过返回ModelAndView对象,进行页面跳转已经登录信息的验证?
       login.jsp中登录验证使用的不是form表单提交,而是使用的ajax请求,ajax请求情况下与ModelAndView有冲突

2 在用户登录功能中,能否通过拦截器对资源进行拦截,从而使在未登录情况下不能直接访问相应的jsp文件?
        springMVC下的拦截器interceptor只拦截controller层,只对请求进行拦截,对.jsp文件并不会经过拦截器
        在web.xml文件中,对dispatchServlet 的servlet映射器配置中,如果配置
                    <url-pattern>*.do</url-pattern>
        的形式,就是对controller进行拦击,如果配置<url-pattern>/</url-pattern>,则对静态资源文件也都会拦截
        (但是同样.jsp文件没有经过拦截器) 两种解决方案:
        1 .jsp文件全部放入WEB-INF目录; 2 使用过滤器
    理解springmvc中过滤器和拦截器的关系

3 request中的url问题  比如说:http://localhost:8080/store/UserServlet?method=findByName
    request.getServletPath()        结果:        /UserServlet 记住不带参数
    request.getContextPath()        结果:        /store
    request.getRequestURI()         结果:        /store/UserServlet
    request.getRequestURL()         结果:        http://localhost:8080/store/UserServlet
          getServletPath():获取能够与“url-pattern”中匹配的路径，注意是完全匹配的部分，*的部分不包括。
          getPageInfo():与getServletPath()获取的路径互补，能够得到的是“url-pattern”中*d的路径部分
          getContextPath():获取项目的根路径
          getRequestURI:获取根路径到地址结尾
          getRequestURL:获取请求的地址链接（浏览器中输入的地址）
          getServletContext().getRealPath(“/”):获取“/”在机器中的实际地址
          getScheme():获取的是使用的协议(http 或https)
          getProtocol():获取的是协议的名称(HTTP/1.11)
          getServerName():获取的是域名(xxx.com)
          getLocalName:获取到的是IP

4