<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
	String basePath = request.getScheme() +
			"://"
			+ request.getServerName() + ":"
			+ 	request.getServerPort()
			+ request.getContextPath() + "/";
%>
<!DOCTYPE html>
<html>
<head>
	<base href="<%=basePath%>">
<meta charset="UTF-8">

<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />

<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>

	<link rel="stylesheet" type="text/css" href="jquery/bs_pagination/jquery.bs_pagination.min.css">
	<script type="text/javascript" src="jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
	<script type="text/javascript" src="jquery/bs_pagination/en.js"></script>

<script type="text/javascript">

	$(function(){


		$("#addBtn").click(function (){

			$(".time").datetimepicker({
				minView: "month",
				language:  'zh-CN',
				format: 'yyyy-mm-dd',
				autoclose: true,
				todayBtn: true,
				pickerPosition: "bottom-left"
			});

			$.ajax({
				url:"workbench/activity/getUserList.do",
				type:"get",
				dataType:"json",
				success:function (data){
					// alert("成功")
					var html = "<option></option>";
					$.each(data,function (i,n){
						html += "<option value='" + n.id +"'>" + n.name+"</option>";
					})

					$("#create-owner").html(html);

					//将当前登录的用户，设置为下拉框默认的选项
					//取得当前登录用户的id，在js中使用el表达式，el表达式一定要套用在字符串中
					var id = "${user.id}";
					$("#create-owner").val(id)

					$("#createActivityModal").modal("show");
				}
			})
		})

		$("#saveBtn").click(function (){
			$.ajax({
				url  : "workbench/activity/save.do",
				type : "get",
				dataType: "json",
				data : {
					"owner" : $.trim($("#create-owner").val()),
					"name" : $.trim($("#create-marketActivityName").val()),
					"startDate" : $.trim($("#create-startDate").val()),
					"endDate" : $.trim($("#create-endTime").val()),
					"cost" : $.trim($("#create-cost").val()),
					"description" : $.trim($("#create-description").val())
				},
				success:function (data){
					if(data.success){

						$("#activityAddForm")[0].reset();

						$("#createActivityModal").modal("hide");

						// pageList(1,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
						pageList(1,4);
					}else {
						alert("添加市场活动失败")
					}
				}

			})
		})

		//页面加载完毕后触发一个方法
		pageList(1,4);

		$("#searchBtn").click(function (){
			//点击搜索框按钮的时候，应该先将搜索框中的信息保存起来,保存到隐藏域中
			$("#hidden-name").val($.trim($("#search-name").val()));
			$("#hidden-owner").val($.trim($("#search-owner").val()));
			$("#hidden-startDate").val($.trim($("#search-startDate").val()));
			$("#hidden-endDate").val($.trim($("#search-endDate").val()));
			pageList(1,4);
		})

		$("#qx").click(function (){
			$("input[name=xz]").prop("checked",this.checked);
		})

		//为动态生成的复选框绑定事件，动态生成的元素，要以on方法的形式来触发事件
		//语法: $(需要绑定元素的有效的外层元素).on("绑定事件的方式",需要绑定的元素的jquery对象,回调函数)
		$("#ActivityBody").on("click",$("input[name=xz]"),function (){
			$("#qx").prop("checked",$("input[name=xz]").length==$("input[name=xz]:checked").length);
		})

		$("#deleteBtn").click(function (){
			var $xz = $("input[name=xz]:checked");

			if($xz.length == 0){
				alert("请选择需要删除的记录！");
			}else{
				var param = "";
				for (var i=0; i < $xz.length;i++){
					param += "id=" + $($xz[i]).val();
					if (i<$xz.length-1){
						param += "&";
					}
				}
				// alert(param);
				if (confirm("您确定要删除所选的记录吗?")){
					$.ajax({
						url:"workbench/activity/delete.do",
						data:param,
						type:"post",
						dataType:"json",
						success:function (data){
							if(data.success){
								alert("删除成功");
								pageList(1,4);
							}else {
								alert("删除市场活动失败");
							}
						}
					})
				}
			}
		})

		$("#editBtn").click(function (){
			var $xz = $("input[name=xz]:checked");

			if($xz.length == 0){
				alert("请选择要修改的记录");
			}else if($xz.length > 1){
				alert("只能选择一条记录进行修改");
			}else {
				$(".time").datetimepicker({
					minView: "month",
					language:  'zh-CN',
					format: 'yyyy-mm-dd',
					autoclose: true,
					todayBtn: true,
					pickerPosition: "bottom-left"
				});

				//jquery对象长度为1的时候可以直接用.val 否则还是$($xz[0]).val()
				var id = $xz.val();
				$.ajax({
					url:"workbench/activity/getUserListAndActivity.do",
					type:"get",
					dataType:"json",
					data:{
						id:id
					},
					success:function (data){
						var html = "<option></option>";

						$.each(data.userList,function (index,user){
							html += "<option value='"+user.id+"'>"+user.name+"</option>";
						})

						$("#edit-marketActivityOwner").html(html);

						//2.处理单条activity
						$("#edit-id").val(data.activity.id);
						$("#edit-marketActivityOwner").val(data.activity.owner);
						$("#edit-marketActivityName").val(data.activity.name);
						$("#edit-startTime").val(data.activity.startDate);
						$("#edit-endTime").val(data.activity.endDate);
						$("#edit-cost").val(data.activity.cost);
						$("#edit-description").val(data.activity.description);

						//所有的值都填写好之后，打开修改操作的模态窗口
						$("#editActivityModal").modal("show");
					}
				})
			}
		})

		$("#updateBtn").click(function (){
			$.ajax({
				url:"workbench/activity/update.do",
				type:"post",
				dataType:"json",
				data:{
					"id" : $.trim($("#edit-id").val()),
					"owner" : $.trim($("#edit-marketActivityOwner").val()),
					"name" : $.trim($("#edit-marketActivityName").val()),
					"startDate" : $.trim($("#edit-startTime").val()),
					"endDate" : $.trim($("#edit-endTime").val()),
					"cost" : $.trim($("#edit-cost").val()),
					"description" : $.trim($("#edit-description").val())
				},
				success:function (data){
					if (data.success){
						//修改成功后，应该维持当前页，维持每页展现的记录数，这两个参数不需要我们进行任何的修改操作，直接使用即可
						pageList($("#activityPage").bs_pagination('getOption', 'currentPage')	//操作后停留在当前页
								,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));	//操作后维持已经设置好的每页展现的记录数

						//关闭修改操作的模态窗口
						$("#editActivityModal").modal("hide");
					}else{
						alert("修改市场活动失败");
					}
				}
			})
		})

		function pageList(pageNo,pageSize){
			//将全选的复选框的√干掉
			$("#qx").prop("checked",false);
			//查询前，将隐藏域中的信息取出来，重新赋予到搜索框中
			$("#search-name").val($.trim($("#hidden-name").val()));
			$("#search-owner").val($.trim($("#hidden-owner").val()));
			$("#search-startDate").val($.trim($("#hidden-startDate").val()));
			$("#search-endDate").val($.trim($("#hidden-endDate").val()));

		//	将全选的复选框√干掉
			$.ajax({
				url : "workbench/activity/pageList.do",
				data : {
					"pageNo" : pageNo,
					"pageSize" : pageSize,
					"name" : $.trim($("#search-name").val()),
					"owner" : $.trim($("#search-owner").val()),
					"startDate" : $.trim($("#search-startDate").val()),
					"endDate" : $.trim($("#search-endDate").val()),
				},
				type : "get",
				dataType:"json",
				success:function (data){
					var html = "";
					$.each(data.dataList,function (i,n){
						html += "<tr class='active'>";
						html += '	<td><input type="checkbox" name="xz" value="'+n.id+'"/></td>';
						html += '	<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/activity/detail.do?id='+n.id+'\';">'+n.name+'</a></td>';
						html += '	<td>'+n.owner+'</td>';
						html += '	<td>'+n.startDate+'</td>';
						html += '	<td>'+n.endDate+'</td>';
						html += '</tr>';
					})
					$("#ActivityBody").html(html);

					//计算总页数
					var totalPages = data.total%pageSize == 0 ? data.total/pageSize : parseInt(data.total/pageSize)+1;

					//数据处理完毕后，结合分页查询，对前端展现分页信息
					$("#activityPage").bs_pagination({
						currentPage: pageNo, // 页码
						rowsPerPage: pageSize, // 每页显示的记录条数
						maxRowsPerPage: 20, // 每页最多显示的记录条数
						totalPages: totalPages, // 总页数
						totalRows: data.total, // 总记录条数

						visiblePageLinks: 3, // 显示几个卡片

						showGoToPage: true,
						showRowsPerPage: true,
						showRowsInfo: true,
						showRowsDefaultInfo: true,

						//该回调函数在点击分页组件的时候触发
						onChangePage : function(event, data){
							pageList(data.currentPage , data.rowsPerPage);
						}
					});
				}
			})
		}



	});
	
</script>
</head>
<body>
	<input type="hidden" id="hidden-name">
	<input type="hidden" id="hidden-owner">
	<input type="hidden" id="hidden-startDate">
	<input type="hidden" id="hidden-endDate">

	<!-- 创建市场活动的模态窗口 -->
	<div class="modal fade" id="createActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">创建市场活动</h4>
				</div>
				<div class="modal-body">
				
					<form id="activityAddForm" class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="create-owner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-owner">
								<%--	从数据库读取用户--%>
								</select>
							</div>
                            <label for="create-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-marketActivityName">
                            </div>
						</div>
						
						<div class="form-group">
							<label for="create-startDate" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="create-startDate">
							</div>
							<label for="create-endTime" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="create-endTime">
							</div>
						</div>
                        <div class="form-group">

                            <label for="create-cost" class="col-sm-2 control-label">成本</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-cost">
                            </div>
                        </div>
						<div class="form-group">
							<label for="create-description" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-description"></textarea>
							</div>
						</div>
						
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button id="saveBtn" type="button" class="btn btn-primary" data-dismiss="modal">保存</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 修改市场活动的模态窗口 -->
	<div class="modal fade" id="editActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel2">修改市场活动</h4>
				</div>
				<div class="modal-body">
				
					<form class="form-horizontal" role="form">
						<input type="hidden" id="edit-id">
						<div class="form-group">
							<label for="edit-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-marketActivityOwner">
									<%--过后台,从数据库取数据--%>

								  <%--<option>zhangsan</option>--%>
								  <%--<option>lisi</option>--%>
								  <%--<option>wangwu</option>--%>
								</select>
							</div>
                            <label for="edit-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-marketActivityName" value="发传单">
                            </div>
						</div>

						<div class="form-group">
							<label for="edit-startTime" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="edit-startTime" value="2020-10-10">
							</div>
							<label for="edit-endTime" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="edit-endTime" value="2020-10-20">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-cost" class="col-sm-2 control-label">成本</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-cost" value="5,000">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-description" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-description">市场活动Marketing，是指品牌主办或参与的展览会议与公关市场活动，包括自行主办的各类研讨会、客户交流会、演示会、新产品发布会、体验会、答谢会、年会和出席参加并布展或演讲的展览会、研讨会、行业交流会、颁奖典礼等</textarea>
							</div>
						</div>
						
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button  type="button" class="btn btn-primary" id="updateBtn">更新</button>
				</div>
			</div>
		</div>
	</div>
	

	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>市场活动列表</h3>
			</div>
		</div>
	</div>
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">名称</div>
				      <input class="form-control" type="text" id="search-name">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input class="form-control" type="text" id="search-owner">
				    </div>
				  </div>


				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">开始日期</div>
					  <input class="form-control" type="text" id="search-startDate" />
				    </div>
				  </div>
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">结束日期</div>
					  <input class="form-control" type="text" id="search-endDate">
				    </div>
				  </div>
				  
				  <button type="button" id="searchBtn" class="btn btn-default">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" id="addBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" id="editBtn"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger" id="deleteBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="qx"/></td>
							<td>名称</td>
                            <td>所有者</td>
							<td>开始日期</td>
							<td>结束日期</td>
						</tr>
					</thead>
					<tbody id="ActivityBody">
						<%--被替换成数据库中的真实--%>
						<%--<tr class="active">--%>
						<%--	<td><input type="checkbox" /></td>--%>
						<%--	<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='workbench/activity/detail.jsp';">发传单</a></td>--%>
                        <%--    <td>zhangsan</td>--%>
						<%--	<td>2020-10-10</td>--%>
						<%--	<td>2020-10-20</td>--%>
						<%--</tr>--%>
                        <%--<tr class="active">--%>
                        <%--    <td><input type="checkbox" /></td>--%>
                        <%--    <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='workbench/activity/detail.jsp';">发传单</a></td>--%>
                        <%--    <td>zhangsan</td>--%>
                        <%--    <td>2020-10-10</td>--%>
                        <%--    <td>2020-10-20</td>--%>
                        <%--</tr>--%>
					</tbody>
				</table>
			</div>
			
			<div style="height: 50px; position: relative;top: 30px;">
				<div id="activityPage"></div>

				<%--<div>--%>
				<%--	<button type="button" class="btn btn-default" style="cursor: default;">共<b>50</b>条记录</button>--%>
				<%--</div>--%>
				<%--<div class="btn-group" style="position: relative;top: -34px; left: 110px;">--%>
				<%--	<button type="button" class="btn btn-default" style="cursor: default;">显示</button>--%>
				<%--	<div class="btn-group">--%>
				<%--		<button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">--%>
				<%--			10--%>
				<%--			<span class="caret"></span>--%>
				<%--		</button>--%>
				<%--		<ul class="dropdown-menu" role="menu">--%>
				<%--			<li><a href="#">20</a></li>--%>
				<%--			<li><a href="#">30</a></li>--%>
				<%--		</ul>--%>
				<%--	</div>--%>
				<%--	<button type="button" class="btn btn-default" style="cursor: default;">条/页</button>--%>
				<%--</div>--%>
				<%--<div style="position: relative;top: -88px; left: 285px;">--%>
				<%--	<nav>--%>
				<%--		<ul class="pagination">--%>
				<%--			<li class="disabled"><a href="#">首页</a></li>--%>
				<%--			<li class="disabled"><a href="#">上一页</a></li>--%>
				<%--			<li class="active"><a href="#">1</a></li>--%>
				<%--			<li><a href="#">2</a></li>--%>
				<%--			<li><a href="#">3</a></li>--%>
				<%--			<li><a href="#">4</a></li>--%>
				<%--			<li><a href="#">5</a></li>--%>
				<%--			<li><a href="#">下一页</a></li>--%>
				<%--			<li class="disabled"><a href="#">末页</a></li>--%>
				<%--		</ul>--%>
				<%--	</nav>--%>
				<%--</div>--%>
			</div>
			
		</div>
		
	</div>
</body>
</html>