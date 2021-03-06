package com.atguigu.crud.service;

import com.atguigu.crud.beans.Department;
import com.atguigu.crud.dao.DepartmentMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class DepartmentService {
    @Autowired
    private DepartmentMapper departmentMapper;

    public List<Department> deptAll(){
        List<Department> departments = departmentMapper.selectByExample(null);
        return departments;
    }

}
