package com.atguigu.crud.service;

import com.atguigu.crud.beans.Employee;
import com.atguigu.crud.dao.EmployeeMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
@Service
public class EmployeeService {
    @Autowired
    EmployeeMapper employeeMapper;

    public List<Employee> getEmpAll(){
        List<Employee> employees = employeeMapper.selectByExampleWithDept(null);
        return employees;
    }


}
