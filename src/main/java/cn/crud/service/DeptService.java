package cn.crud.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cn.crud.bean.Department;
import cn.crud.dao.DepartmentMapper;

/**
 * 处理部门的service
 * @author Administrator
 *
 */
@Service
public class DeptService {

	//注入mapper
	@Autowired
	private DepartmentMapper departmentMapper;
	/**
	 * 返回所有部门信息的方法
	 * @return
	 */
	public List<Department> getDepts() {
		List<Department> deptList = departmentMapper.selectByExample(null);
		return deptList;
	}

	
}
