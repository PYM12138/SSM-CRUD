package com.atguigu.crud.controller;

import com.atguigu.crud.beans.Employee;
import com.atguigu.crud.beans.Msg;
import com.atguigu.crud.service.EmployeeService;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.github.pagehelper.PageInterceptor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

/**
 * 员工的CRUD
 */
@Controller
public class EmployeeController {

    @Autowired
    EmployeeService employeeService;

   // @RequestMapping("/emps")
    public String getEmps(@RequestParam(value = "pn",defaultValue = "1") Integer pn, Model model){

        //2.分页(需要引入插件和配置mybatis-config.xml文件)
        PageHelper.startPage(pn, 5);
        //1.获取所有的员工信息
        List<Employee> empAll = employeeService.getEmpAll();
        //3.分页信息包装,分页信息，导航数(也就是每页显示5个页码)
        PageInfo<Employee> pageInfo = new PageInfo<Employee>(empAll, 5);
        //4.传值到域中
        model.addAttribute("pageInfo", pageInfo);
        return  "list";
    }


    @RequestMapping("/emps")
    @ResponseBody
    public Msg getEmpsWithJson(@RequestParam(value = "pn",defaultValue = "1" )Integer pn){
        //        //2.分页(需要引入插件和配置mybatis-config.xml文件)
        PageHelper.startPage(pn, 5);
        //1.获取所有的员工信息
        List<Employee> empAll = employeeService.getEmpAll();
        //3.分页信息包装,分页信息，导航数(也就是每页显示5个页码)
        PageInfo<Employee> pageInfo = new PageInfo<Employee>(empAll, 5);
        return Msg.success().add("pageInfo", pageInfo);
    }



}
