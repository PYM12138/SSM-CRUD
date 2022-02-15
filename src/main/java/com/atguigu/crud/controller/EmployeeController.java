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
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.validation.Valid;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 员工的CRUD
 */
@Controller
public class EmployeeController {

    @Autowired
    private EmployeeService employeeService;

    //防止恶意禁用JS，默认为false,只要没有用checkEmpName方法，就永远都是false
    Boolean aBoolean =false;

    //修改员工
    //这里要注意，ajax请求可以直接发送put请求，但是tomcat不会给你封装。spring MVC则提供一个处理这个问题的过滤器，开启即可
    //解决办法2：就是ajax发送POST请求，在传递过来的数据中发送带上_method=put也行
    @RequestMapping(value = "/emp/{empId}",method = RequestMethod.PUT)
    @ResponseBody
    public Msg updateEmp(Employee employee){
        Integer integer = employeeService.updateEmp(employee);
        if (integer>0){
            return Msg.success();
        }

        return Msg.fail();

    }


    //查询单个员工
    @RequestMapping(value = "/emp/{id}",method = RequestMethod.GET)
    @ResponseBody
    public Msg getEmpSingle(@PathVariable("id") Integer id){
        Employee empSingle = employeeService.getEmpSingle(id);
        return Msg.success().add("empSingle", empSingle);

    }



    @RequestMapping(value = "/checkEmpName",method = RequestMethod.POST)
    @ResponseBody
    public Msg checkEmpName(@RequestParam("empName") String empName){//用户名重复校验
        aBoolean = employeeService.checkEmp(empName);
        if (aBoolean){//主要是里面的状态码，在前台进行一个判断
            return Msg.success();
        }else{
            return Msg.fail();

        }
    }

    /*
     * 后端校验：JSR303
     * 需要hibernate-validator包
     *
     * @valid 启用校验
     * BindingResult 错误信息存储
     *
     * */
    @RequestMapping(value = "/emp",method = RequestMethod.POST)
    @ResponseBody
    public Msg saveEmp(@Valid Employee employee, BindingResult bindingResult){//保存员工数据
        if (aBoolean){
            if (bindingResult.hasErrors()){//有错误信息
                //保存信息并传到前台
                Map<String, Object> map = new HashMap<>();
                //首先获取错误信息
                List<FieldError> fieldErrors = bindingResult.getFieldErrors();
                for (FieldError fieldError : fieldErrors) {//循环获取每一个错误
                    System.out.println("错误的字段名:"+fieldError.getField());
                    System.out.println("错误的信息提示:"+fieldError.getDefaultMessage());
                    map.put(fieldError.getField(),fieldError.getDefaultMessage());
                }
                return Msg.fail().add("errorField",map);
            }else{
                employeeService.saveEmp(employee);
                return Msg.success();
            }
        }
       return Msg.fail();


    }


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
