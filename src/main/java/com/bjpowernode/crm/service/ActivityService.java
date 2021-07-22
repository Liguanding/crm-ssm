package com.bjpowernode.crm.service;

import com.bjpowernode.crm.domain.Activity;
import com.bjpowernode.crm.vo.PaginationVO;

import java.util.Map;

public interface ActivityService {
    boolean save(Activity activity);

    PaginationVO<Activity> pageList(Map<String, Object> map);

    boolean delete(String[] ids);

    Map<String,Object> getUserListAndActivity(String id);

    boolean update(Activity activity);

    Activity detail(String id);
}
