package com.bjpowernode.crm.web.filter;

import com.bjpowernode.crm.domain.User;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class LoginFilter implements Filter {
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain) throws IOException, ServletException {
        System.out.println("进入过滤器");
        HttpServletRequest request = (HttpServletRequest)servletRequest;
        HttpServletResponse response = (HttpServletResponse)servletResponse;
        if("/login.jsp".equals(request.getServletPath()) || "/settings/user/login.do".equals(request.getServletPath())){
            filterChain.doFilter(request,response);
        }else {
            HttpSession session = request.getSession();
            User user = (User)session.getAttribute("user");
            if(user != null){
                filterChain.doFilter(request,response);
            }else {
                response.sendRedirect(request.getServletPath()+"/login.jsp");
            }
        }
    }

    @Override
    public void destroy() {

    }
}
