package cn.crud.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import cn.crud.bean.Department;
import cn.crud.bean.Msg;
import cn.crud.service.DeptService;

/**
 * 处理和部门有关的请求的controller
 * @author Administrator
 *
 */
@Controller
public class DeptController {

	//controller中注入service
	@Autowired
	private DeptService deptService;
	
	/**
	 * 返回部门信息的controller方法
	 * @return
	 */
	@RequestMapping("/depts")
	@ResponseBody
	public Msg getDepts(){
		//查出所有部门信息
		List<Department> deptList = deptService.getDepts();
		//调用Msg的静态方法，返回我们自定义的数据
		return Msg.success().add("deptList", deptList);
	}
}
