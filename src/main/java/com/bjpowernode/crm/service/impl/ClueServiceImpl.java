package com.bjpowernode.crm.service.impl;

import com.bjpowernode.crm.dao.ClueDao;
import com.bjpowernode.crm.dao.UserDao;
import com.bjpowernode.crm.domain.Activity;
import com.bjpowernode.crm.domain.Clue;
import com.bjpowernode.crm.domain.User;
import com.bjpowernode.crm.service.ClueService;
import com.bjpowernode.crm.vo.PaginationVO;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class ClueServiceImpl implements ClueService {

    @Resource
    private ClueDao clueDao;
    @Resource
    private UserDao userDao;

    @Override
    public PaginationVO<Clue> cluePageList(Map<String, Object> map) {
        //取得total
        int total = clueDao.getTotalByCondition(map);
        //取得dataList
        List<Clue> dataList =  clueDao.getClueListByCondition(map);
        //创建一个vo将total和dataList封装到vo中
        PaginationVO vo = new PaginationVO();
        vo.setTotal(total);
        vo.setDataList(dataList);
        return vo;
    }

    @Override
    public boolean save(Clue clue) {
        boolean flag = true;
        int cnt = clueDao.save(clue);
        if(cnt != 1){
            flag = false;
        }
        return flag;
    }

    @Override
    public boolean delete(String[] ids) {
        boolean flag = true;
        int count1 = clueDao.getCountByIds(ids);

        int count2 = clueDao.deleteByAids(ids);
        if(count1 != count2){
            flag = false;
        }
        return flag;
    }

    @Override
    public Map<String, Object> getUserListAndClue(String id) {
        Map<String,Object> map = new HashMap<>();
        List<User> userList = userDao.getUserList();
        Clue clue = clueDao.getClueById(id);
        map.put("userList",userList);
        map.put("clue",clue);
        return map;
    }

    @Override
    public boolean update(Clue clue) {
        boolean flag = true;
        int count = clueDao.update(clue);
        if (count != 1) {
            flag = false;
        }
        return flag;
    }
}
