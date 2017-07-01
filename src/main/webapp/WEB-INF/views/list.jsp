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
<!-- 推荐以 / 开始的相对路径（以服务器的根路径为相对路径） -->
<link href="${path}/static/bootstrap/css/bootstrap.min.css" rel="stylesheet">
 <!-- 先引入jQuery，再引入js -->
<script type="text/javascript" src="${path}/static/bootstrap/js/jquery.min.js"> </script>
<script src="${path}/static/bootstrap/js/bootstrap.min.js"></script>
</head>
<body>
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
				<button type="button" class="btn btn-primary ">新增</button>
				<button type="button" class="btn btn-danger ">删除</button>
			</div>
		</div>
		<!-- 表格 -->
		<div class="row">
			<div class="col-md-12">
				<table class="table table-hover">
					<tr>
						<th>#</th>
						<th>empName</th>
						<th>empEmail</th>
						<th>gender</th>
						<th>deptName</th>
						<th>操作</th>
					</tr>
					<c:forEach items="${pageInfo.list }" var="emp">
						<tr>
							<td>${emp.empId}</td>
							<td>${emp.empName}</td>
							<td>${emp.email}</td>
							<!-- 三元运算符展示性别信息 -->
							<td>${emp.gender=="M"?"男":"女"}</td>
							<td>${emp.department.deptName}</td>
							<td>
								<button type="button" class="btn btn-info btn-sm">
								<span class="glyphicon glyphicon-pencil" aria-hidden="true"></span>
									编辑</button>
								<button type="button" class="btn btn-danger btn-sm">
								<span class="glyphicon glyphicon-trash" aria-hidden="true"></span>
									删除</button>
							</td>
						</tr>
					</c:forEach>
				</table>
			</div>
		</div>
		<!-- 分页信息 -->
		<div class="row">
			<!-- 分页文字信息，其中分页信息都封装在pageInfo中 -->
			<div class="col-md-6">
				当前第：${pageInfo.pageNum}页，总共：${pageInfo.pages}页，总共：${pageInfo.total}条记录
			</div>
			<!-- 分页条 -->
			<div class="col-md-6">
				<nav aria-label="Page navigation">
				  <ul class="pagination">
				  	<li><a href="${path}/emps?pn=1">首页</a></li>
				  	<c:if test="${pageInfo.hasPreviousPage }">
				  		 <li>
					      <a href="${path}/emps?pn=${pageInfo.pageNum-1}" aria-label="Previous">
					        <span aria-hidden="true">&laquo;</span>
					      </a>
					    </li>
				  	</c:if>

				    <c:forEach items="${pageInfo.navigatepageNums }" var="page_Num">
				    	<c:if test="${page_Num == pageInfo.pageNum }">
				    		<li class="active"><a href="#">${page_Num}</a></li>
				    	</c:if>
				    	<c:if test="${page_Num != pageInfo.pageNum }">
				    		<li><a href="${path}/emps?pn=${page_Num}">${page_Num}</a></li>
				    	</c:if>
				    </c:forEach> 
				    <c:if test="${pageInfo.hasNextPage }">
					    <li>
					      <a href="${path}/emps?pn=${pageInfo.pageNum+1}" aria-label="Next">
					        <span aria-hidden="true">&raquo;</span>
					      </a>
					    </li>
				    </c:if>   
				    <li><a href="${path}/emps?pn=${pageInfo.pages}">末页</a></li>
				  </ul>
				</nav>
			</div>
		</div>
	</div>
</body>
</html>