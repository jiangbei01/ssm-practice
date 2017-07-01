<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>员工列表</title>
<%
	pageContext.setAttribute("path",request.getContextPath());
%>
<!-- 推荐以 / 开始的相对路径（以服务器的根路径为相对路径） ,这里的${path}是前带 / 后不带 / 的路径-->
<link href="${path}/static/bootstrap/css/bootstrap.min.css" rel="stylesheet">
 <!-- 先引入jQuery，再引入js -->
<script type="text/javascript" src="${path}/static/bootstrap/js/jquery.min.js"> </script>
<script src="${path}/static/bootstrap/js/bootstrap.min.js"></script>
</head>
<body>
	<!-- 员工修改模态框 -->
	<div class="modal fade" id="editEmpModal" tabindex="-1" role="dialog">
	  <div class="modal-dialog" role="document">
	    <div class="modal-content">
	      <div class="modal-header">
	        <button type="button" class="close" data-dismiss="modal"><span>&times;</span></button>
	        <h4 class="modal-title">员工修改</h4>
	      </div>
	      <div class="modal-body">
	        <form class="form-horizontal">
			  <!-- 显示员工姓名的静态组件 -->
			  <div class="form-group">
			    <label for="input_empName" class="col-sm-2 control-label">empName</label>
			    <div class="col-sm-10">
			     <p class="form-control-static" id="empName_static"></p>
			    </div>
			  </div>
			  <!-- 输入员工邮箱 -->
			  <div class="form-group">
			    <label for="input_email" class="col-sm-2 control-label">email</label>
			    <div class="col-sm-10">
			      <input type="text" name="email" class="form-control" id="input_update_email" placeholder="email">
			      <span class="help-block"></span>
			    </div>
			  </div>
			  <!-- 选择员工性别 -->
			  <div class="form-group">
			    <label class="col-sm-2 control-label">gender</label>
			    <div class="col-sm-10">
			      <label class="radio-inline">
					  <input type="radio" name="gender" id="gender1_update_input" value="M"> 男
					</label>
					<label class="radio-inline">
					  <input type="radio" name="gender" id="gender2_update_input" value="F"> 女
					</label>
			    </div>
			  </div>
			 <!-- 部门名称 -->
			 <div class="form-group">
			  	<label class="col-sm-2 control-label">deptName</label>
			　　　<div class="col-sm-4" style="width:120px">	
					<!-- 部门名称是变动的，这里保存员工是只保存ID的形式 -->
					<select class="form-control" name="dId">
						
					</select>
			  	</div>
			　</div>
			</form>
	      </div>
	      <!-- 页脚按钮操作 -->
	      <div class="modal-footer">
	        <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
	        <button type="button" class="btn btn-primary" id="emp_updateBtn">更新</button>
	      </div>
	    </div>
	  </div>
	</div>
	
	<!-- 员工新增模态框 -->
	<div class="modal fade" id="addEmpModal" tabindex="-1" role="dialog">
	  <div class="modal-dialog" role="document">
	    <div class="modal-content">
	      <div class="modal-header">
	        <button type="button" class="close" data-dismiss="modal"><span>&times;</span></button>
	        <h4 class="modal-title" id="myModalLabel">添加员工</h4>
	      </div>
	      <div class="modal-body">
	        <form class="form-horizontal">
			  <!-- 输入员工姓名 -->
			  <div class="form-group">
			    <label for="input_empName" class="col-sm-2 control-label">empName</label>
			    <div class="col-sm-10">
			      <input type="text" name="empName" class="form-control" id="input_empName" placeholder="empName">
			      <span class="help-block"></span>
			    </div>
			  </div>
			  <!-- 输入员工邮箱 -->
			  <div class="form-group">
			    <label for="input_email" class="col-sm-2 control-label">email</label>
			    <div class="col-sm-10">
			      <input type="text" name="email" class="form-control" id="input_email" placeholder="email">
			      <span class="help-block"></span>
			    </div>
			  </div>
			  <!-- 选择员工性别 -->
			  <div class="form-group">
			    <label class="col-sm-2 control-label">gender</label>
			    <div class="col-sm-10">
			      <label class="radio-inline">
					  <input type="radio" name="gender" id="gender1_add_input" value="M" checked="checked"> 男
					</label>
					<label class="radio-inline">
					  <input type="radio" name="gender" id="gender2_add_input" value="F"> 女
					</label>
			    </div>
			  </div>
			 <!-- 部门名称 -->
			 <div class="form-group">
			  	<label class="col-sm-2 control-label">deptName</label>
			　　　<div class="col-sm-4" style="width:120px">	
					<!-- 部门名称是变动的，这里保存员工是只保存ID的形式 -->
					<select class="form-control" name="dId">
						
					</select>
			  	</div>
			　</div>
			</form>
	      </div>
	      <!-- 页脚按钮操作 -->
	      <div class="modal-footer">
	        <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
	        <button type="button" class="btn btn-primary" id="emp_saveBtn">保存</button>
	      </div>
	    </div>
	  </div>
	</div>
	<div class="container">
		<!-- 分为四大行 -->
		<!-- 标题 -->
		<div class="row">
			 <div class="col-md-12">
				<font size="20">SSM-CRUD</font>
			 </div>
		</div>
		<!-- 按钮 -->
		<div class="row">
			<!-- 偏移4列 -->
			<div class="col-md-4 col-md-offset-8">
				<button type="button" class="btn btn-primary" id="addBtn">新增</button>
				<button type="button" class="btn btn-danger" id="delAllBtn">删除</button>
			</div>
		</div>
		<!-- 表格 -->
		<div class="row">
			<div class="col-md-12">
				<table class="table table-hover" id="emps_table">
					<thead>
						<tr>
							<!-- 新增批量删除的checkbox -->
							<th>
								<input type="checkbox" id="check_all"/>
							</th>
							<th>#</th>
							<th>empName</th>
							<th>empEmail</th>
							<th>gender</th>
							<th>deptName</th>
							<th>操作</th>
						</tr>
					</thead>
					<tbody>
					
					</tbody>
				</table>
			</div>
		</div>
		<!-- 分页信息 -->
		<div class="row">
			<!-- 分页文字信息，其中分页信息都封装在pageInfo中 -->
			<div class="col-md-6" id="page_info">
				
			</div>
			<!-- 分页条 -->
			<div class="col-md-6" id="page_nav">
				
			</div>
		</div>
	</div>
	<script type="text/javascript">
		//全局总记录数，用于查最后一页
		var golbalTotalCount,golbalCurrentPage;
		//页面加载完成后直接发送ajax请求，取得分页数据
		$(function(){
			//加载完页面就通过这个函数发ajax请求
			toPage(1);
		});
		//跳转到某页的函数
		function toPage(pn){
			$.ajax({
				//请求方式
				type : "GET", 
				//请求url
				url : "${path}/emps",
				//请求要带的数据
				data :"pn="+pn,
				//请求成功的回调函数
				success : function(result) {
					//1.解析JSON返回员工数据
					build_emps_table(result);
					//2.解析生成分页信息(分页条与分页导航)
					build_pages_info(result);
					build_pages_nav(result);
				}
			});
		}
		//解析员工数据
		function build_emps_table(result){
			//清空表格数据
			$("#emps_table tbody").empty();
			//员工数据
			var emps = result.map.pageInfo.list;
			//使用jQuery遍历数组，遍历的是取出来的json数组，可以通过开发工具查看JSON结构
			$.each(emps,function(idx,item){
				//增加删除的多选框
				var checkboxTd = $("<td><input type='checkbox' class='check_item'/></td>");
				//使用jQuery生成各列
				var empIdTd = $("<td></td>").append(item.empId);
				var empNameTd = $("<td></td>").append(item.empName);
				//三目运算符处理性别
				var genderTd = $("<td></td>").append(item.gender=="M"?"男":"女");
				var emailTd = $("<td></td>").append(item.email);
				var deptNameTd = $("<td></td>").append(item.department.deptName);
				//添加操作按钮，通过jQuery的一些操作（例如CSS的追加CSS操作），完成按钮的构建
				var editBtn = $("<button></button>").addClass("btn btn-info btn-sm edit_btn")
								.append($("<span></span>").addClass("glyphicon glyphicon-pencil"))
								.append("编辑");
				//为编辑按钮添加自定义属性，保存员工的ID
				editBtn.attr("editId",item.empId);
				var delBtn = $("<button></button>").addClass("btn btn-danger btn-sm del_btn")
				.append($("<span></span>").addClass("glyphicon glyphicon-trash"))
				.append("删除");
				//为删除按钮添加自定义属性，保存要删除的员工ID
				delBtn.attr("delId",item.empId);
				var btnTd = $("<td></td>").append(editBtn).append(" ").append(delBtn);
				//链式操作完成列的添加（链式操作由于jQuery返回的是原元素）
				$("<tr></tr>").append(checkboxTd)
					.append(empIdTd)
					.append(empNameTd)
					.append(emailTd)
					.append(genderTd)
					.append(deptNameTd)
					.append(btnTd)
					.appendTo($("#emps_table tbody"));
			});
		}
		//生成分页信息
		function build_pages_info(result){
			//清空分页数据
			$("#page_info").empty();
			//当前页
			var currentPage = result.map.pageInfo.pageNum;
			//总页数
			var totalPage = result.map.pageInfo.pages;
			//总记录数
			var totalCount = result.map.pageInfo.total;
			//给全局记录数赋值
			golbalTotalCount = result.map.pageInfo.total;
			//给当前页赋值，完成当前页信息的保存
			golbalCurrentPage = currentPage;
			$("#page_info").append("当前第：<strong>"+currentPage+" </strong> 页，"+"总共：<strong>"+totalPage+"</strong> 页，"+"总共：<strong>"+totalCount+" </strong> 条记录");
		}
		//生成分页导航信息
		function build_pages_nav(result){
			//清空分页导航信息
			$("#page_nav").empty();
			//导航条外层的Ul
			var navUl = $("<ul></ul>").addClass("pagination");
			//首页
			var firstPageLi = $("<li></li>").append($("<a></a>").append("首页").attr("href","#"));
			//前一页
			var prePageLi = $("<li></li>").append($("<a></a>").append("&laquo;"));
			//判断是否有首页
			if(result.map.pageInfo.hasPreviousPage == false){
				firstPageLi.addClass("disabled");
				prePageLi.addClass("disabled");
			}else{
				//添加首页和前一页翻页的单机事件
				firstPageLi.click(function(){
					toPage(1);
				});
				prePageLi.click(function(){
					toPage(result.map.pageInfo.pageNum-1);
				});
			}
			
			//后一页
			var nextPageLi = $("<li></li>").append($("<a></a>").append("&raquo;"));
			//末页
			var lastPageLi = $("<li></li>").append($("<a></a>").append("末页").attr("href","#"));
			//判断是否有末页
			if(result.map.pageInfo.hasNextPage == false){
				lastPageLi.addClass("disabled");
				nextPageLi.addClass("disabled");
			}else{
				//添加末页和后一页翻页的单机事件
				lastPageLi.click(function(){
					toPage(result.map.pageInfo.pages);
				});
				nextPageLi.click(function(){
					toPage(result.map.pageInfo.pageNum+1);
				});
			}
			
			//添加到ul
			navUl.append(firstPageLi).append(prePageLi);
			
			//遍历页码数
			$.each(result.map.pageInfo.navigatepageNums,function(idx,item){
				var numLi = $("<li></li>").append($("<a></a>").append(item));
				//如果当前页为正在遍历的页，则高亮显示，采用增加类的方法完成
				if(result.map.pageInfo.pageNum == item){
					numLi.addClass("active");
				}
				//给每个页码添加单击绑定事件
				numLi.click(function(){
					toPage(item);
				});
				navUl.append(numLi);
			});
			//li加入ul，ul加入nav
			navUl.append(nextPageLi).append(lastPageLi);
			var navEle = $("<nav></nav>").append(navUl);
			$("#page_nav").append(navEle);
		}
		//清空表单样式及内容
		function reset_form(ele){
			$(ele)[0].reset();
			//清空表单样式
			$(ele).find("*").removeClass("has-error has-success");
			$(ele).find(".help-block").text("");
		}
		//增加员工的事件，弹出员工模态框
		$("#addBtn").click(function(){
			//重置表单：
			reset_form("#addEmpModal form");
			//发送ajax请求查询部门信息
			getDepts("#addEmpModal select");
			//弹出模态框
			$('#addEmpModal').modal({
				backdrop:false
			});
		});
		//得到部门信息的函数
		function getDepts(ele){
			//先清空原来下拉框的值：
			$(ele).empty();
			$.ajax({
				//请求方式
				type : "GET", 
				//请求url
				url : "${path}/depts",
				//请求要带的数据，这里无需带数据
				//请求成功的回调函数
				success : function(result) {
					$.each(result.map.deptList,function(){
						//这里换用不传参的方式，采用this引用正在遍历的对象
						var optionEle = $("<option></option>").append(this.deptName).attr("value",this.deptId);
						optionEle.appendTo(ele);
					});
				}
			});
		}
		//添加表单数据的前段校验
		function validate_add_form(){
			//1.获取需要校验的值
			//2.使用jQuery正则(api中常用正则)进行校验（校验插件的使用待更新）
			var empNameVal = $("#input_empName").val();
			//校验的正则表达式（可以搜索常用正则）
			var regName = /(^[a-zA-Z0-9_-]{6,16}$)|(^[\u2E80-\u9FFF]{2,5}$)/;
			//开始校验用户名
			if(!regName.test(empNameVal)){
				//alert("用户名只能是6-16位英文数字或2-5位汉字组合！");
				//将提示信息优化，使用bootstrap的样式，给父元素添加相应的类即可
				vilidate_form("#input_empName","error","用户名只能是6-16位英文数字或2-5位汉字组合！");
				//$("#input_empName").parent().addClass("has-error");
				//$("#input_empName").next(".help-block").text("用户名只能是6-16位英文数字或2-5位汉字组合！");
				return false;
			}else{
				vilidate_form("#input_empName","success","用户名正确！");
				//$("#input_empName").parent().addClass("has-success");
				//$("#input_empName").next(".help-block").text("用户名正确！");
			}
			//同理，校验邮箱
			var empEmailVal = $("#input_email").val();
			var regEmail = /^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/;
			//开始校验邮箱
			if(!regEmail.test(empEmailVal)){
				//alert("邮箱不合法！");
				vilidate_form("#input_email","error","邮箱不合法！");
				//$("#input_email").parent().addClass("has-error");
				//$("#input_email").next(".help-block").text("邮箱不合法！");
				return false;
			}else{
				vilidate_form("#input_email","success","邮箱格式正确！");
				//$("#input_email").parent().addClass("has-success");
				//$("#input_email").next(".help-block").text("邮箱格式正确！");
			}
			return true;
		}
		//重新抽取校验函数完成之前重复样式的清除工作
		function vilidate_form(ele,status,msg){
				//清除当前校验状态
				$(ele).parent().removeClass("has-success has-error");
				$(ele).next(".help-block").text("");
			if("success" == status){
				$(ele).parent().addClass("has-success");
				$(ele).next(".help-block").text(msg);
			}else if("error" == status){
				$(ele).parent().addClass("has-error");
				$(ele).next(".help-block").text(msg);
			}
		}
		//为添加员工姓名输入框添加change事件，完成用户名重复的后端校验
		$("#input_empName").change(function(){
			//发送ajax请求，查询用户名是否重复
			var empName = this.value;
			$.ajax({
				//请求方式
				type : "POST", 
				//请求url
				url : "${path}/vadEmpName",
				//请求要带的数据
				data:"empName="+empName,
				//请求成功的回调函数
				success : function(result) {
					if(result.code == 100){//成功，用户名可用
						vilidate_form("#input_empName","success","用户名可用！");
						$("#emp_saveBtn").attr("ajax-vad","success");
					}else{//失败，用户名不可用
						vilidate_form("#input_empName","error",result.map.vadFailMeg);
						$("#emp_saveBtn").attr("ajax-vad","error");
					}
				}
			});
		});
		//为添加员工的保存按钮绑定单击事件
		$("#emp_saveBtn").click(function(){
			
			//1.5发送ajax请求之前进行用户名是否可用的校验：
			if($(this).attr("ajax-vad")=="error"){
				return false;
			}
			//1.进行表单数据的校验
			 if(!validate_add_form()){
				return false;
			} 
			//2.模态框中保存按钮发送ajax请求
			$.ajax({
				//请求方式
				type : "POST", 
				//请求url
				url : "${path}/emp",
				//请求要带的数据，这里是模态框中的值，
				//这里应该采用的是jQuery的序列化表单的方法进行提取表单数据，serialize();
				//表单序列化的数据：$("#addEmpModal form").serialize();
				data:$("#addEmpModal form").serialize(),
				//请求成功的回调函数
				success : function(result) {
					//alert(result.msg);
					//添加一个后端校验：
					if(result.code == 100){//校验成功
						//1.成功完成模态框则关闭
						$("#addEmpModal").modal('hide')
						//2.来到列表最后一页
						//发送ajax请求，显示最后一页，因为插件做了参数合理化配置，可以配置一个比较大的数字
						//这样，查到的总是最后一页记录，我们使用全局的总记录数
						toPage(golbalTotalCount);
					}else{//校验失败
						//console.log(result);
						var emailErrorMsg = result.map.fieldErrors.email;
						var empNameErrorMsg = result.map.fieldErrors.empName;
						//有哪个字段的信息就显示哪个
						if(undefined != emailErrorMsg){
							//显示邮箱错误信息（之前已经抽象为 方法）
							vilidate_form("#input_email","error",emailErrorMsg);
						}
						if(undefined != empNameErrorMsg){
							//显示名称错误信息
							vilidate_form("#input_empName","error",empNameErrorMsg);
						}
					}
					
				}
			});
		});
		//根据id得到员工信息的函数
		function getEmp(id){
			//发送ajax请求查询员工信息
			$.ajax({
				//REST风格的url，直接使用/传参
				url:"${path}/getEmp/"+id,
				type:"GET",
				success:function(result){
					console.log(result);
					var empData = result.map.emp;
					//在页面的指定位置显示相关的值
					$("#empName_static").text(empData.empName);
					$("#input_update_email").val(empData.email);
					//合理使用选择器，选择修改模态框的gender
					//将单选框的选中项改为val为指定值的选项
					$("#editEmpModal input[name=gender]").val([empData.gender]);
					//$("#editEmpModal input[name='genger'][value='"+empData.gender+"']").prop("checked",true);
					//$("#gender2_update_input").val([empData.gender]);
					//下拉框同理
					$("#editEmpModal select").val([empData.dId]);
				}
			});
		}
		/*直接给页面的新增按钮绑定单击事件时不行的，因为按钮是通过发送ajax请求加载数据时
			加载的，而我们的click()是页面加载完时绑定的事件，也就是说按钮事件先于按钮出生的时间
			于是，便出现了问题
		*/
		//这里详细的on的用法暂时不展开
		$(document).on("click",".edit_btn",function(){
			//alert("绑定编辑事件成功！");
			//1.查出部门信息，员工信息等
				//这里重新抽取一下得到部门的方法，使其可以得到指定的部门信息，添加到指定的元素
			//发送ajax请求查询部门信息
			getDepts("#editEmpModal select");
			//通过为编辑按钮添加自定义属性保存ID值，可以方便的完成ID值的保存与获取
			getEmp($(this).attr("editId"));
			
			//弹出模态框之前传递ID值给更新按钮
			$("#emp_updateBtn").attr("updateId",$(this).attr("editId"));
			//2.弹出修改模态框
			$('#editEmpModal').modal({
				backdrop:false
			});
		});
		//为更新按钮绑定单击事件，进行更新
		$("#emp_updateBtn").click(function(){
			//由于有邮箱输入，更新之前需要进行邮箱的格式验证
			//直接抽取前面的代码进行校验邮箱
			var empEmailVal = $("#input_update_email").val();
			var regEmail = /^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/;
			//开始校验邮箱
			if(!regEmail.test(empEmailVal)){
				vilidate_form("#input_update_email","error","邮箱不合法！");
				return false;
			}else{
				vilidate_form("#input_update_email","success","邮箱格式正确！");
			}
			//取得要更新的ID
			var udpId = $(this).attr("updateId");
			//邮箱验证通过，发送ajax的PUT请求，完成员工更新
			$.ajax({
				//要根据ID更新，需要取得ID的值，通过同样的自定义属性的方法，将ID传到按钮上
				
				url:"${path}/updateEmp/"+udpId,
				type:"PUT",
				//数据时序列化表单的数据
				data:$("#editEmpModal form").serialize(),
				success:function(result){
					//alert("处理成功！");
					//1.关闭模态框框
					$("#editEmpModal").modal('hide');
					//2.回到本页面，本页面如何获取呢，我们通过构建分页条时的pageInfo得到本页页码
						//再像之前保存总记录数一样，保存本页数据到全局变量即可！
					toPage(golbalCurrentPage);
				}
			});
		});
		//同理，为后来动态生成的删除按钮绑定单击事件，依旧使用on方法
		$(document).on("click",".del_btn",function(){
			//1.弹出确认删除对话框（需要获取员工姓名进行确认）
				//这里下标从0开始，加了元素后td为第三个td
			var empName = $(this).parents("tr").find("td:eq(2)").text();
			var delID = $(this).attr("delId");
			if(confirm("确认删除："+empName+" 吗？")){
				//确认胡发送ajax请求进行删除
				$.ajax({
					url:"${path}/deleteEmp/"+delID,
					type:"DELETE",
					//无数据传送
					success:function(result){
						//alert(result.msg);
						//2.回到本页面，本页面如何获取呢，我们通过构建分页条时的pageInfo得到本页页码
						//再像之前保存总记录数一样，保存本页数据到全局变量即可！
					toPage(golbalCurrentPage);
					}
				});
			}
		});
		//全选框的单击事件：
		$("#check_all").click(function(){
			//直接使用attr()时是undefined，因为我们定义的时候没有定义，我们使用prop()
			//$(this).prop("checked");
			//下面的单个的框的值就是全选的状态的值
			$(".check_item").prop("checked",$(this).prop("checked"));
		});
		//为后来动态生成的check_item绑定单击事件，完成未选满时全选框不选中
		$(document).on("click",".check_item",function(){
			//若当前选中的元素为5个全选，则全选按钮选中
				//当然，这里不能写死，如果将来变为6个7个还需改动
			var flag = $(".check_item:checked").length == $(".check_item").length;
				$("#check_all").prop("checked",flag);
			
		});
		//为批量删除按钮绑定单击事件
		$("#delAllBtn").click(function(){
			//$(".check_item:checked")
			//遍历每一个被选中的多选框
				//将员工姓名拼串
				var empNames = "";
				var empIds="";
			$.each($(".check_item:checked"),function(){
				//寻找要删除的员工姓名
				var empName = $(this).parents("tr").find("td:eq(2)").text();
				empNames += empName+",";
				//组装员工ID字符串，和组装姓名类似，只不过id所在列不一样
				var empId = $(this).parents("tr").find("td:eq(1)").text();
				empIds += empId+"-";
			});
			//去除多余的逗号
			empNames = empNames.substring(0,empNames.length-1);
			//去掉多余的 -
			empIds = empIds.substring(0,empIds.length-1);
			if(confirm("确认删除："+empNames+" 吗?")){
				//确认删除，发ajax请求
				$.ajax({
					url:"${path}/deleteEmp/"+empIds,
					type:"DELETE",
					success:function(result){
						alert(result.msg);
						//依旧回到本页面
						toPage(golbalCurrentPage);
					}
				});
			}
		});
	</script>
</body>
</html>