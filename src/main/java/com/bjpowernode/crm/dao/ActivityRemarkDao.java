package com.bjpowernode.crm.dao;

public interface ActivityRemarkDao {
    int getCountByAids(String[] ids);

    int deleteByAids(String[] ids);

    int deleteRemark(String id);
}
