package com.bjpowernode.crm.service;

import com.bjpowernode.crm.exception.LoginException;
import com.bjpowernode.crm.domain.User;

import java.util.List;


public interface UserService {
    User queryUser(String loginAct, String loginPwd,String ip) throws LoginException;
    List<User> getUserList();
}
