package com.bjpowernode.crm.dao;

import com.bjpowernode.crm.domain.User;

import java.util.List;
import java.util.Map;

public interface UserDao {
    User login(Map<String, Object> map);

    List<User> getUserList();
}
