package com.bjpowernode.crm.controller;

import com.bjpowernode.crm.domain.Activity;
import com.bjpowernode.crm.domain.ActivityRemark;
import com.bjpowernode.crm.domain.User;
import com.bjpowernode.crm.service.ActivityService;
import com.bjpowernode.crm.service.UserService;
import com.bjpowernode.crm.utils.DateTimeUtil;
import com.bjpowernode.crm.utils.PrintJson;
import com.bjpowernode.crm.utils.UUIDUtil;
import com.bjpowernode.crm.vo.PaginationVO;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/workbench/activity")
public class ActivityController {
    @Resource
    private UserService userService;
    @Resource
    private ActivityService activityService;


    @RequestMapping("/getUserList.do")
    @ResponseBody
    public List<User> getUserList(){
        List<User> userList = userService.getUserList();
        return userList;
    }

    @RequestMapping("/save.do")
    public void save(Activity activity, HttpServletRequest request, HttpServletResponse response){
        activity.setId(UUIDUtil.getUUID());
        activity.setCreateTime(DateTimeUtil.getSysTime());
        activity.setCreateBy( ((User)request.getSession().getAttribute("user")).getName());

        boolean save = activityService.save(activity);
        PrintJson.printJsonFlag(response,save);
    }

    @RequestMapping("/pageList.do")
    @ResponseBody
    private PaginationVO<Activity> pageList(String name,String owner,String startDate,String endDate,Integer pageNo,Integer pageSize){
        int beginIndex = (pageNo-1) * pageSize;
        Map<String,Object> map = new HashMap<>();
        map.put("name",name);
        map.put("owner",owner);
        map.put("startDate",startDate);
        map.put("endDate",endDate);
        map.put("beginIndex",beginIndex);
        map.put("pageSize",pageSize);
        //将来分页查询，每个模块都有，所以我们选择使用一个通用vo paginationVO<T>, 操作起来比较方便
        PaginationVO<Activity> vo;
        vo = activityService.pageList(map);
        return vo;
    }

    @RequestMapping(value = "/delete.do",method = RequestMethod.POST)
    @ResponseBody
    private void delete(HttpServletRequest request,HttpServletResponse response){
        String[] ids = request.getParameterValues("id");
        boolean flag = activityService.delete(ids);
        PrintJson.printJsonFlag(response,flag);
    }

    @RequestMapping(value = "/getUserListAndActivity.do")
    @ResponseBody
    private Map<String,Object> getUserListAndActivity(String id){
        Map<String,Object> map = activityService.getUserListAndActivity(id);
        return map;
    }

    @RequestMapping(value = "/update.do")
    @ResponseBody
    private void update(Activity activity,HttpServletResponse response,HttpServletRequest request){
        //修改时间
        activity.setEditTime(DateTimeUtil.getSysTime());
        //修改人
        activity.setEditBy(((User)request.getSession().getAttribute("user")).getName());
        boolean flag = activityService.update(activity);
        PrintJson.printJsonFlag(response,flag);
    }

    //跳转到详细信息页的操作
    @RequestMapping("/detail.do")
    private ModelAndView detail(String id){
        ModelAndView mv = new ModelAndView();
        Activity activity = activityService.detail(id);
        mv.addObject("activity",activity);
        mv.setViewName("activity/detail");
        return mv;
    }

    @ResponseBody
    @RequestMapping("/getRemarkListByAid.do")
    private List<ActivityRemark> getRemarkListByAid(String activityId){
        List<ActivityRemark> activityRemarkList = activityService.getRemarkListByAid(activityId);
        return activityRemarkList;
    }

    @RequestMapping("/deleteRemark.do")
    private void deleteRemark(String id,HttpServletResponse response){
        boolean flag = activityService.deleteRemark(id);
        PrintJson.printJsonFlag(response,flag);
    }

    @ResponseBody
    @RequestMapping("/saveRemark.do")
    private Map<String,Object> saveRemark(String noteContent,String activityId,HttpServletRequest request){
        String id = UUIDUtil.getUUID();
        String createTime = DateTimeUtil.getSysTime();
        String createBy = ((User)request.getSession().getAttribute("user")).getName();
        String editFlag = "0";
        ActivityRemark ar = new ActivityRemark();
        ar.setActivityId(activityId);
        ar.setNoteContent(noteContent);
        ar.setId(id);
        ar.setCreateTime(createTime);
        ar.setCreateBy(createBy);
        ar.setEditBy(editFlag);
        boolean flag = activityService.saveRemark(ar);
        Map<String,Object> map = new HashMap<>();
        map.put("success",flag);
        map.put("ar",ar);
        return map;
    }


    @ResponseBody
    @RequestMapping("/updateRemark.do")
    private Map<String,Object> updateRemark(String noteContent,String id,HttpServletRequest request){
        String editTime = DateTimeUtil.getSysTime();
        String editBy = ((User) request.getSession().getAttribute("user")).getName();
        String editFlag = "1";
        ActivityRemark ar = new ActivityRemark();
        ar.setId(id);
        ar.setNoteContent(noteContent);
        ar.setEditBy(editBy);
        ar.setEditTime(editTime);
        ar.setEditFlag(editFlag);
        boolean flag = activityService.updateRemark(ar);
        Map<String,Object> map = new HashMap<>();
        map.put("success",flag);
        map.put("ar",ar);
        return map;
    }

}
