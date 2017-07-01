package cn.crud.tests;

import java.util.List;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;

import com.github.pagehelper.PageInfo;

import cn.crud.bean.Employee;

/**
 * 使用spring的单元测试来进行模拟发送请求的测试
 * @author Administrator
 *
 */
@RunWith(SpringJUnit4ClassRunner.class)
@WebAppConfiguration
@ContextConfiguration(locations={"classpath:applicationContext.xml",
									"file:src/main/webapp/WEB-INF/dispatcherServlet-servlet.xml"})
public class MVCTest {

	//springMVC的IOC容器
	@Autowired
	private WebApplicationContext context;
	//模拟MVC请求
	private MockMvc mockMvc;
	
	@Before
	public void setup(){
		mockMvc = MockMvcBuilders.webAppContextSetup(context).build();
	}
	
	@Test
	public void testPage() throws Exception{
		//模拟请求拿到返回值
		 MvcResult result = mockMvc.perform(MockMvcRequestBuilders.get("/emps").param("pn", "2"))
				 .andReturn();
		 //请求域中有pageInfo
		 PageInfo page = (PageInfo) result.getRequest().getAttribute("page");
		 System.out.println(page.getPageNum());
		 System.out.println(page.getTotal());
		 
		 //得到员工数据
		 List<Employee> list = page.getList();
		 for (Employee employee : list) {
			System.out.println("ID:"+employee.getdId()+" 性别:"+employee.getGender());
		}
	}
}
