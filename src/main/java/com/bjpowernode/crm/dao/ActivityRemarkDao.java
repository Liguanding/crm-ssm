package com.bjpowernode.crm.dao;

import com.bjpowernode.crm.domain.ActivityRemark;

import java.util.List;

public interface ActivityRemarkDao {
    int getCountByAids(String[] ids);

    int deleteByAids(String[] ids);

    int deleteRemark(String id);

    List<ActivityRemark> getRemarkListByAid(String activityId);

    boolean saveRemark(ActivityRemark ar);

    int updateRemark(ActivityRemark ar);
}
