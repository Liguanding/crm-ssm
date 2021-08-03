package com.bjpowernode.crm.controller;

import com.bjpowernode.crm.domain.Clue;
import com.bjpowernode.crm.domain.User;
import com.bjpowernode.crm.service.ActivityService;
import com.bjpowernode.crm.service.ClueService;
import com.bjpowernode.crm.service.UserService;
import com.bjpowernode.crm.utils.DateTimeUtil;
import com.bjpowernode.crm.utils.PrintJson;
import com.bjpowernode.crm.utils.UUIDUtil;
import com.bjpowernode.crm.vo.PaginationVO;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/workbench/clue")
public class ClueController {
    @Resource
    private ClueService clueService;
    @Resource
    private UserService userService;
    @Resource
    private ActivityService activityService;


    @ResponseBody
    @RequestMapping(value = "/cluePageList.do")
    private PaginationVO<Clue> cluePageList(String name,String company,String mphone,String sourece,String owner,String phone,
                                            String state,Integer pageNo, Integer pageSize){
        int beginIndex = (pageNo-1) * pageSize;
        Map<String,Object> map = new HashMap<>();
        map.put("beginIndex",beginIndex);
        map.put("pageSize",pageSize);
        map.put("name",name);
        map.put("company",company);
        map.put("source",sourece);
        map.put("owner",owner);
        map.put("phone",phone);
        map.put("mphone",mphone);
        map.put("state",state);
        System.out.println("name ==========" + name);
        PaginationVO<Clue> vo;
        vo = clueService.cluePageList(map);
        return vo;
    }

    @ResponseBody
    @RequestMapping(value = "/getUserList.do")
    private List<User> getUserList(){
        List<User> userList = userService.getUserList();
        return userList;
    }

    @ResponseBody
    @RequestMapping(value = "/save.do")
    private void saveClue(Clue clue, HttpServletResponse response, HttpServletRequest request){
        String id = UUIDUtil.getUUID();
        String createTime = DateTimeUtil.getSysTime();
        String createBy = ((User)request.getSession().getAttribute("user")).getName();
        clue.setId(id);
        clue.setCreateTime(createTime);
        clue.setCreateBy(createBy);
        boolean flag = clueService.save(clue);
        PrintJson.printJsonFlag(response,flag);
    }

    @ResponseBody
    @RequestMapping(value = "/delete.do",method = RequestMethod.POST)
    private void deleteClue(HttpServletResponse response, HttpServletRequest request){
        String[] ids = request.getParameterValues("id");
        boolean flag = clueService.delete(ids);
        PrintJson.printJsonFlag(response,flag);
    }

    @ResponseBody
    @RequestMapping(value = "/getUserListAndClue.do")
    private Map<String,Object> getUserListAndClue(String id){
        Map<String,Object> map = clueService.getUserListAndClue(id);
        return map;
    }

    @ResponseBody
    @RequestMapping(value = "/updateClue.do")
    private void updateClue(Clue clue, HttpServletResponse response, HttpServletRequest request){
        String editTime = DateTimeUtil.getSysTime();
        String editBy = ((User)request.getSession().getAttribute("user")).getName();
        clue.setEditTime(editTime);
        clue.setEditBy(editBy);
        boolean flag = clueService.update(clue);
        PrintJson.printJsonFlag(response,flag);
    }
}
