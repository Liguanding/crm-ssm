package com.bjpowernode.crm.service.impl;

import com.bjpowernode.crm.dao.DicTypeDao;
import com.bjpowernode.crm.dao.DicValueDao;
import com.bjpowernode.crm.service.DicService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;

@Service
public class DicServiceImpl implements DicService {

    @Resource
    private DicTypeDao dicTypeDao;

    @Resource
    private DicValueDao dicValueDao;

}
