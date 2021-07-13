package com.bjpowernode.crm.settings.web.controller;

import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.settings.service.UserService;
import com.bjpowernode.crm.utils.MD5Util;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping(value = "/user")
public class UserController {

    @Resource
    private UserService userService;

    @RequestMapping(value = "/login.do")
    @ResponseBody
    public Map<String,Object> login(String loginAct, String loginPwd, HttpServletRequest request) {
        System.out.println("进入到用户控制器");
        System.out.println("loginAct : " + loginAct + "       " + "loginPwd" + loginPwd);
        loginPwd = MD5Util.getMD5(loginPwd);
        String ip = request.getRemoteAddr();
        System.out.println("当前请求登录的ip为: " + ip);
        Map<String,Object> res = new HashMap<>();
        try {
            User user = userService.login(loginAct,loginPwd,ip);
            request.getSession().setAttribute("user",user);
            res.put("success",true);
        }catch (Exception e){
            e.printStackTrace();
            String msg = e.getMessage();
            System.out.println(msg+"======================");
            res.put("success",false);
            res.put("msg",msg);
        }
        return res;
    }



}
