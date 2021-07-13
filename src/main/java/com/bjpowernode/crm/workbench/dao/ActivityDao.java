package com.bjpowernode.crm.workbench.dao;

import com.bjpowernode.crm.workbench.domain.Activity;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository(value = "activityDao")
public interface ActivityDao {
    int save(Activity at);

    List<Activity> getActivityByCondition(Map<String,Object> map);
}
