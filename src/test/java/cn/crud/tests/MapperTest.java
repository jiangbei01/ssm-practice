package cn.crud.tests;

import java.util.UUID;

import org.apache.ibatis.session.SqlSession;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import cn.crud.bean.Department;
import cn.crud.bean.Employee;
import cn.crud.dao.DepartmentMapper;
import cn.crud.dao.EmployeeMapper;

/**
 * 测试dao层的环境
 * @author Administrator
 *1.使用@ContextConfiguration指定配置文件路径
 *2.使用@Runwith指定单元测试使用spring的单元测试
 *3.可以像原生开发一样直接注入
 */
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations={"classpath:applicationContext.xml"})
public class MapperTest {

	@Autowired
	private DepartmentMapper departmentMapper;
	@Autowired
	private EmployeeMapper employeeMapper;
	@Autowired
	private SqlSession sqlSession;
	/**
	 * 测试dept表的Mapper
	 */
	@Test
	public void TestDao(){
//		部门插入
//		departmentMapper.insertSelective(new Department(null,"宣传部"));
//		departmentMapper.insertSelective(new Department(null,"测试部"));
//		员工插入
//		employeeMapper.insertSelective(new Employee(null,"Alan","M","1001@qq.com",1));
//		employeeMapper.insertSelective(new Employee(null,"Bob","F","1002@qq.com",2));
		//通过此方法得到的mapper可以批量操作
		EmployeeMapper mapper = sqlSession.getMapper(EmployeeMapper.class);
		for(int i = 0; i<500; i++){
			String gender = i%2==0?"M":"F";
			String uid = UUID.randomUUID().toString().substring(0, 5);
			mapper.insertSelective(new Employee(null, uid, gender, uid+"@qq.com", 1));
		}
		System.out.println("批量完成");
	}
}
