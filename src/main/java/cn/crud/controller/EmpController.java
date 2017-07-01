package cn.crud.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.validation.Valid;

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

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;

import cn.crud.bean.Employee;
import cn.crud.bean.Msg;
import cn.crud.service.EmpService;

/**
 * 处理员工的CRUD请求
 * @author Administrator
 *
 */
@Controller
public class EmpController {
	
	@Autowired
	private EmpService empService;
	
	/**
	 * 按照ID单个删除的方法
	 * 注意这是个RESTful风格的DELETE请求
	 * @return
	 */
	/*@RequestMapping(value="/deleteEmp/{id}",method=RequestMethod.DELETE)
	@ResponseBody
	public Msg deleteEmpByID(@PathVariable("id") Integer id){
		//System.out.println(id);
		//调用sevice进行删除处理
		empService.deteleEmp(id);
		return Msg.success();
	}*/
	/**
	 * 将单个与批量二合一
	 * @return
	 */
	@RequestMapping(value="/deleteEmp/{ids}",method=RequestMethod.DELETE)
	@ResponseBody
	public Msg deleteEmpByID(@PathVariable("ids") String ids){
		if(ids.contains("-")){//包含-则为多个删除
			//按- 分割为字符数组
			String[] del_ids = ids.split("-");
			//组装符合要求的id数组
			List<Integer> idsList = new ArrayList<Integer>();
			for (String id : del_ids) {
				idsList.add(Integer.parseInt(id));
			}
			empService.deleteBatch(idsList);
			return Msg.success();
		}else{//单个删除
			Integer id = Integer.parseInt(ids);
			//调用sevice进行删除处理
			empService.deteleEmp(id);
			return Msg.success();
		}
		
	}
	/**
	 * 保存员工的ajax请求的方法
	 * 这里我们引入RESTful风格的PUT请求
	 *可以发送时由于我们之前有RESTful风格的配置
	 * 此处必须使得占位符的名称与bean的属性名称一致
	 * 如果直接发送ajax的PUT请求，会造成除了路径带过来的id，其余都是Null，造成请求对象封装不上
	 * SQL就会变成：update table where id = ? 的形式，形成语法错误
	 * 	而造成这种错误的原因就是
	 * 			tomcat把请求中的数据封装在一个map中
	 * 			而springMVC只是调用request.getParameter()进行取值
	 * 			我们可以猜测直接拿request原生方法也是无法取值的！
	 * 	这里我们得出结论：
	 * 		PUT请求不能直接发！tomcat不会直接封装，查看相关源码分析会发现默认只封装POST！
	 * 		springMVC针对这个情况也有对应的解决方案，配置一个过滤器：HttpPutFormContentFilter
	 * @return
	 */
	@RequestMapping(value="/updateEmp/{empId}",method=RequestMethod.PUT)
	@ResponseBody
	public Msg updateEmp(Employee employee){
		//System.out.println(employee);
		//调用service完成逻辑
		empService.updateEmp(employee);
		return Msg.success();
	}
	
	/**
	 * 处理得到员工信息ajax请求的方法
	 * 统一将返回信息封装在Msg中
	 * !这里开始使用RESTful风格的url
	 * @PathVariable("id")当名称相同时是可以省略的
	 * 					【更新】：无法省略！
	 * @return
	 */
	@RequestMapping(value="/getEmp/{id}",method=RequestMethod.GET)
	@ResponseBody
	public Msg getEmp(@PathVariable("id") Integer id){
		//System.out.println("controller层获取的ID:"+id);
		//调用service完成操作
		Employee employee = empService.getEmp(id);
		//System.out.println(employee);
		//将serivce返回的对象返回给页面
		return Msg.success().add("emp", employee);
	}
	
	/**
	 * 校验用户名是否重复，是否可用的方法
	 * @return 返回的是我们包装的对象
	 */
	@RequestMapping("/vadEmpName")
	@ResponseBody
	public Msg vadEmpName(@RequestParam("empName") String empName){
		//在判断是否重复之前，先进行格式是否正确的校验
		//校验的正则表达式（可以搜索常用正则）
		//特别注意这里的正则和js的正则不一样，加 / 包裹的是js的写法
		String regName = "(^[a-zA-Z0-9_-]{6,16}$)|(^[\u2E80-\u9FFF]{2,5}$)";
		boolean b = empName.matches(regName);
		if(!b){
			return Msg.fail().add("vadFailMeg", "用户名格式错误！");
		}
		//后端用户名重复性校验
		boolean isRepet = empService.vadEmpName(empName);
		if(isRepet){
			return Msg.success();
		}else{
			return Msg.fail().add("vadFailMeg", "用户名已被占用！");
		}
		
	}
	
	/**
	 * 处理添加员工的ajax请求的方法
	 * 　1.要支持JSR303后端校验，需要导入hibernate-validate的包
	 * 2.在bean的属性中添加相关的注解
	 * 3.在方法入参添加相关的注解
	 * 	@Valid后跟需要校验的对象，BindingResult时校验的结果
	 * @return
	 */
	@RequestMapping(value="/emp",method=RequestMethod.POST)
	@ResponseBody
	public Msg saveEmp(@Valid Employee employee,BindingResult result){
		if(result.hasErrors()){//若存在错误，校验失败
			//保存错误信息的map,便于封装
			Map<String,Object> errors = new HashMap<String,Object>();
			//返回错误信息
			List<FieldError> fieldErrors = result.getFieldErrors();
			for (FieldError fieldError : fieldErrors) {//遍历错误信息
				//错误的字段名：
				System.out.println("错误的字段名："+fieldError.getField());
				//错误的提示信息
				System.out.println("错误信息："+fieldError.getDefaultMessage());
				//封装错误信息
				errors.put(fieldError.getField(), fieldError.getDefaultMessage());
			}
			//最后封装如Msg的map中进行返回
			return Msg.fail().add("fieldErrors", errors);
		}else{
			empService.saveEmp(employee);
			return Msg.success();
		}
		
	}
	
	/**
	 * 分页信息的AJAX请求
	 * @ResponseBody可以将返回的对象转为JSON字符串
	 * 此注解需要引入jackson的包（以及注解驱动的配置等，这里已经进行配置）
	 * 将返回信息包装在msg里
	 */
	@RequestMapping("/emps")
	@ResponseBody
	public Msg getEmpsWithJson(@RequestParam(value="pn",defaultValue="1") Integer pn, Model model){
		//改造为一个分页查询
		//在查询之前传入分页参数：起始页和每页记录数
		PageHelper.startPage(pn, 5);
		//后面紧跟的查询就是分页查询
		List<Employee> empList = empService.getAll();
		//用PageInfo对结果进行包装，只需要将PageInfo交给页面即可，这里面封装了详细的信息,第二个参数为需要连续显示的记录数
		PageInfo page = new PageInfo(empList,5);
		//直接将pageInfo对象进行返回
		//将pageInfo放在msg里进行返回，链式操作返回对象本身
		return Msg.success().add("pageInfo", page);
	}
	
	/**
	 * 分页查询员工数据
	 */
	//@RequestMapping("/emps")
	public String getEmps(@RequestParam(value="pn",defaultValue="1") Integer pn, Model model){
		//改造为一个分页查询
		//在查询之前传入分页参数：起始页和每页记录数
		PageHelper.startPage(pn, 5);
		//后面紧跟的查询就是分页查询
		List<Employee> empList = empService.getAll();
		//用PageInfo对结果进行包装，只需要将PageInfo交给页面即可，这里面封装了详细的信息,第二个参数为需要连续显示的记录数
		PageInfo page = new PageInfo(empList,5);
		model.addAttribute("pageInfo", page);
		return "list";
	}
}
