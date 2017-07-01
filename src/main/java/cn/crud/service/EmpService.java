package cn.crud.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cn.crud.bean.Employee;
import cn.crud.bean.EmployeeExample;
import cn.crud.bean.EmployeeExample.Criteria;
import cn.crud.dao.EmployeeMapper;
/**
 * 处理员工的service
 * @author Administrator
 *
 */
@Service
public class EmpService {
	
	@Autowired
	private EmployeeMapper employeeMapper;

	/**
	 * 查询所有员工
	 * @return
	 */
	public List<Employee> getAll() {
		/**
		 * 没有查询条件的查询所有，带部门信息
		 */
		return employeeMapper.selectByExampleWithDept(null);
	}
	/**
	 * 增加员工
	 * @param employee
	 */
	public void saveEmp(Employee employee) {
		//我们选择有选择的保存，因为ID是自增的
		employeeMapper.insertSelective(employee);
		
	}
	/**
	 * 检验用户名是否可用
	 * @param empName
	 * @return
	 */
	public boolean vadEmpName(String empName) {
		/*按要求统计符合条件记录数，返回一个整数*/
		//构建example
		EmployeeExample example = new EmployeeExample();
		//构建查询条件 criteria
		Criteria criteria = example.createCriteria();
		//构建条件
		criteria.andEmpNameEqualTo(empName);
		//返回符合条件的记录数，==0时可用
		long count = employeeMapper.countByExample(example);
		return count == 0;
	}
	/**
	 * 根据ID查询出整个员工信息
	 * @param id
	 * @return
	 */
	public Employee getEmp(Integer id) {
		//System.out.println("service层获取的ID:"+id);
		//调用dao层的方法
		Employee employee = employeeMapper.selectByPrimaryKey(id);
		return employee;
	}
	/**
	 * 更新员工的方法
	 * @param employee
	 */
	public void updateEmp(Employee employee) {
		// 选择按照主键有选择的更新（姓名等无法进行更细）
		employeeMapper.updateByPrimaryKeySelective(employee);
		
	}
	/**
	 * 按照ID删除员工
	 * @param id
	 */
	public void deteleEmp(Integer id) {
		//调用dao删除即可
		employeeMapper.deleteByPrimaryKey(id);
		
	}
	public void deleteBatch(List<Integer> idsList) {
		EmployeeExample example = new EmployeeExample();
		Criteria criteria = example.createCriteria();
		//id再某个范围的 delete from where id in()...
		criteria.andEmpIdIn(idsList);
		//按照条件删除
		employeeMapper.deleteByExample(example);
		
	}


}
