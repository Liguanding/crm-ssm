package com.bjpowernode.crm.service.impl;

import com.bjpowernode.crm.dao.ActivityDao;
import com.bjpowernode.crm.dao.ActivityRemarkDao;
import com.bjpowernode.crm.dao.UserDao;
import com.bjpowernode.crm.domain.Activity;
import com.bjpowernode.crm.domain.ActivityRemark;
import com.bjpowernode.crm.domain.User;
import com.bjpowernode.crm.service.ActivityService;
import com.bjpowernode.crm.vo.PaginationVO;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class ActivityServiceImpl implements ActivityService {

    @Resource
    private UserDao userDao;

    @Resource
    private ActivityDao activityDao;

    @Resource
    private ActivityRemarkDao activityRemarkDao;


    @Override
    public boolean save(Activity activity) {
        boolean flag = activityDao.save(activity);
        return flag;
    }

    @Override
    public PaginationVO<Activity> pageList(Map<String, Object> map){
        List<Activity> activityList = activityDao.getActivityListByCondition(map);
        int total = activityDao.getTotalByCondition(map);

        PaginationVO paginationVO = new PaginationVO();
        paginationVO.setDataList(activityList);
        paginationVO.setTotal(total);
        return paginationVO;
    }

    @Override
    public boolean delete(String[] ids){
        boolean flag = true;
        //查询需要删除的备注的数量
        int count1 = activityRemarkDao.getCountByAids(ids);
        //删除备注
        int count2 = activityRemarkDao.deleteByAids(ids);
        if(count1 != count2){
            flag = false;
        }

        //删除市场活动
        int count3 = activityDao.delete(ids);
        if(count3 != ids.length)
            flag = false;
        return flag;
    }

    @Override
    public Map<String, Object> getUserListAndActivity(String id) {
        List<User> userList = userDao.getUserList();
        Activity activity = activityDao.getById(id);
        Map<String,Object> map = new HashMap<>();
        map.put("userList",userList);
        map.put("activity",activity);
        return map;
    }

    @Override
    public boolean update(Activity activity) {
        boolean flag =  true;
        int count = activityDao.update(activity);
        if(count != 1){
            flag = false;
        }
        return flag;
    }

    @Override
    public Activity detail(String id) {
        Activity activity = activityDao.detail(id);
        return activity;
    }

    @Override
    public List<ActivityRemark> getRemarkListByAid(String activityId) {
        List<ActivityRemark> activityRemarkList = activityRemarkDao.getRemarkListByAid(activityId);
        return activityRemarkList;
    }

    @Override
    public boolean deleteRemark(String id) {
        boolean flag = true;
        int count = activityRemarkDao.deleteRemark(id);
        if(count != 1){
            flag = false;
        }
        return flag;
    }

    @Override
    public boolean saveRemark(ActivityRemark ar) {
        boolean flag = activityRemarkDao.saveRemark(ar);
        return flag;
    }

    @Override
    public boolean updateRemark(ActivityRemark ar) {
        boolean flag = true;
        int count = activityRemarkDao.updateRemark(ar);
        if (count != 1){
            flag = false;
        }
        return flag;
    }
}
