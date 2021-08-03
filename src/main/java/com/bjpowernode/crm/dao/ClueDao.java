package com.bjpowernode.crm.dao;

import com.bjpowernode.crm.domain.Clue;

import java.util.List;
import java.util.Map;

public interface ClueDao {
    int getTotalByCondition(Map<String, Object> map);

    List<Clue> getClueListByCondition(Map<String, Object> map);

    int save(Clue clue);

    int getCountByIds(String[] ids);

    int deleteByAids(String[] ids);

    Clue getClueById(String id);

    int update(Clue clue);
}
