package com.atguigu.crud.service;

import com.atguigu.crud.beans.Employee;
import com.atguigu.crud.beans.EmployeeExample;
import com.atguigu.crud.dao.EmployeeMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
@Service
public class EmployeeService {
    @Autowired
    private EmployeeMapper employeeMapper;

    public List<Employee> getEmpAll(){
        EmployeeExample employeeExample=new EmployeeExample();
        employeeExample.setOrderByClause("emp_id");
        List<Employee> employees = employeeMapper.selectByExampleWithDept(employeeExample);
        return employees;
    }


    public void saveEmp(Employee employee) {
        employeeMapper.insertSelective(employee);
    }

    /**
     *
     * @return true代表没有查到数据，用户名可用；false代表查询到重复数据，用户名不可用
     * */
    public Boolean checkEmp(String empName) {
        EmployeeExample employeeExample = new EmployeeExample();
        EmployeeExample.Criteria criteria = employeeExample.createCriteria();
        criteria.andEmpNameEqualTo(empName);
        long l = employeeMapper.countByExample(employeeExample);
        return l==0;
    }

    public Employee getEmpSingle(Integer id) {
        Employee employee = employeeMapper.selectByPrimaryKey(id);
        return employee;

    }

    public Integer updateEmp(Employee employee) {
        int i = employeeMapper.updateByPrimaryKeySelective(employee);
        return i;
    }
}
