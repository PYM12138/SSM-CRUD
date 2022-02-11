import com.atguigu.crud.beans.Department;
import com.atguigu.crud.beans.Employee;
import com.atguigu.crud.dao.DepartmentMapper;
import com.atguigu.crud.dao.EmployeeMapper;
import org.apache.ibatis.session.SqlSession;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import java.util.List;
import java.util.UUID;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations={"classpath:Application.xml"})
public class MapperTest {

    @Autowired
    DepartmentMapper departmentMapper;

    @Autowired
    EmployeeMapper employeeMapper;

    @Autowired
    SqlSession sqlSession;

    @Test
    public void test1(){

       // System.out.println(departmentMapper);

//        departmentMapper.insertSelective(new Department(null,"开发部"));
//        departmentMapper.insertSelective(new Department(null,"测试部"));
//        Department department = departmentMapper.selectByPrimaryKey(1);
//        List<Department> departments = departmentMapper.selectByExample(null);
//        System.out.println(departments);
        EmployeeMapper mapper = sqlSession.getMapper(EmployeeMapper.class);
//        for(int i = 0;i<1000;i++){
//            String uid = UUID.randomUUID().toString().substring(0,5)+i;
//            mapper.insertSelective(new Employee(null,uid,"M", uid+"@atguigu.com", 1, null));
//        }
        List<Employee> employees = mapper.selectByExample(null);
        System.out.println(employees);
        System.out.println("批量完成");
        System.out.println();
        System.out.println();
        System.out.println("master");
        System.out.println();
        System.out.println("master1");



    }

}
