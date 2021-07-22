package com.bjpowernode.crm.dao;

import com.bjpowernode.crm.domain.Activity;

import java.util.List;
import java.util.Map;

public interface ActivityDao {
    boolean save(Activity activity);

    List<Activity> getActivityListByCondition(Map<String, Object> map);//根据条件查询

    int getTotalByCondition(Map<String, Object> map);//选择查询的总条数

    Activity getById(String id);

    int delete(String[] ids);

    int update(Activity activity);

    Activity detail(String id);
}
