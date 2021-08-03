package com.bjpowernode.crm.service;

import com.bjpowernode.crm.domain.Clue;
import com.bjpowernode.crm.vo.PaginationVO;

import java.util.Map;

public interface ClueService {
    PaginationVO<Clue> cluePageList(Map<String, Object> map);

    boolean save(Clue clue);

    boolean delete(String[] ids);

    Map<String, Object> getUserListAndClue(String id);

    boolean update(Clue clue);
}
