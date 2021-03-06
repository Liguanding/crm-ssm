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
		$(".time").datetimepicker({
			minView: "month",
			language:  'zh-CN',
			format: 'yyyy-mm-dd',
			autoclose: true,
			todayBtn: true,
			pickerPosition: "top-left"
		});

		cluePageList(1,4);

		$("#addBtn").click(function (){
			$.ajax({
				url : "workbench/clue/getUserList.do",
				type : "get",
				dataType : "json",
				success : function (data) {
					var html = "";
					$.each(data,function (i,n){
						html += "<option value='" + n.id +"'>" + n.name + "</option>";
					})
					$("#create-owner").html(html);

					var id = "${user.id}";
					$("#create-owner").val(id);
					$("#createClueModal").modal("show");
				}
			})
		})

		$("#saveBtn").click(function (){
			$.ajax({
				url : "workbench/clue/save.do",
				type : "post",
				dataType : "json",
				data : {
					"owner" : $.trim($("#create-owner").val()),
					"company" : $.trim($("#create-company").val()),
					"appellation" : $.trim($("#create-appellation").val()),
					"fullname" : $.trim($("#create-fullname").val()),
					"job" : $.trim($("#create-job").val()),
					"email" : $.trim($("#create-email").val()),
					"phone" : $.trim($("#create-phone").val()),
					"website" : $.trim($("#create-website").val()),
					"mphone" : $.trim($("#create-mphone").val()),
					"state" : $.trim($("#create-state").val()),
					"source" : $.trim($("#create-source").val()),
					"description" : $.trim($("#create-description").val()),
					"contactSummary" : $.trim($("#create-contactSummary").val()),
					"nextContactTime": $.trim($("#create-nextContactTime").val()),
					"address" : $.trim($("#create-address").val()),
				},
				success : function (data){
					if(data.success){
						$("#createClueModal").modal("hide");
						cluePageList(1,4);
					}else {
						alert("??????????????????!")
					}
				}
			})
		})

		$("#deleteBtn").click(function (){
			var $xz = $("input[name=xz]:checked");
			if($xz.length == 0){
				alert("??????????????????????????????");
			}else{
				var param = "";
				for(var i=0; i < $xz.length; i++){
					param += "id=" + $($xz[i]).val();

					if(i < $xz.length-1){
						param += "&";
					}
				}

				if(confirm("???????????????????????????????")){
					$.ajax({
						url : "workbench/clue/delete.do",
						type : "post",
						dataType : "json",
						data : param,
						success : function (data){
							if(data.success){
								cluePageList(1,4);
							}else {
								alert("??????????????????!");
							}
						}
					})
				}

			}
		})


		$("#editBtn").click(function (){
			var $xz = $("input[name=xz]:checked");
			if($xz.length == 0){
				alert("??????????????????????????????");
			}else if($xz.length > 1){
				alert("????????????????????????????????????");
			}else{
				var id = $xz.val();

				$.ajax({
					url : "workbench/clue/getUserListAndClue.do",
					type : "get",
					data : {
						id : id
					},
					dataType : "json",
					success : function (data) {
						var html = "";
						$.each(data.userList,function (i,n){
							html += "<option value='" + n.id +"'>" + n.name + "</option>";
						})
						$("#edit-owner").html(html);

						$("#edit-id").val(id);

						$("#edit-company").val(data.clue.company);
						$("#edit-job").val(data.clue.job);
						$("#edit-fullname").val(data.clue.fullname);
						$("#edit-appellation").val(data.clue.appellation);
						$("#edit-email").val(data.clue.email);
						$("#edit-phone").val(data.clue.phone);
						$("#edit-source").val(data.clue.source);
						$("#edit-description").val(data.clue.description);
						$("#edit-contactSummary").val(data.clue.contactSummary);
						$("#edit-nextContactTime").val(data.clue.nextContactTime);
						$("#edit-address").val(data.clue.address);
						$("#editClueModal").modal("show");
					}
				})
			}
		})

		$("#updateBtn").click(function (){
			$.ajax({
				url : "workbench/clue/updateClue.do",
				data : {
					"id" : $.trim($("#edit-id").val()),
					"owner" : $.trim($("#edit-owner").val()),
					"company" : $.trim($("#edit-company").val()),
					"appellation" : $.trim($("#edit-appellation").val()),
					"fullname" : $.trim($("#edit-fullname").val()),
					"job" : $.trim($("#edit-job").val()),
					"email" : $.trim($("#edit-email").val()),
					"phone" : $.trim($("#edit-phone").val()),
					"website" : $.trim($("#edit-website").val()),
					"mphone" : $.trim($("#edit-mphone").val()),
					"state" : $.trim($("#edit-state").val()),
					"source" : $.trim($("#edit-source").val()),
					"description" : $.trim($("#edit-description").val()),
					"contactSummary" : $.trim($("#edit-contactSummary").val()),
					"nextContactTime": $.trim($("#edit-nextContactTime").val()),
					"address" : $.trim($("#edit-address").val())
				},
				dataType : "json",
				type : "post",
				success : function (data){
					if(data.success){
						cluePageList(1,4);
						$("#editClueModal").modal("hide");
					}else{
						alert("????????????!");
					}
				}
			})
		})

		$("#searchBtn").click(function (){
			$("#hidden-name").val($.trim($("#search-name").val()));
			$("#hidden-company").val($.trim($("#search-company").val()));
			$("#hidden-mphone").val($.trim($("#search-mphone").val()));
			$("#hidden-source").val($.trim($("#search-source").val()));
			$("#hidden-owner").val($.trim($("#search-owner").val()));
			$("#hidden-phone").val($.trim($("#search-phone").val()));
			$("#hidden-state").val($.trim($("#search-state").val()));

			cluePageList(1,4);
		})


		$("#qx").click(function (){
			$("input[name=xz]").prop("checked",this.checked);
		})



	});

	function cluePageList(pageNo,pageSize){
		//???????????????????????????
		$("#qx").prop("checked",false);

		//???????????????????????????????????????????????????????????????????????????
		$("#search-name").val($.trim($("#hidden-name").val()));
		$("#search-company").val($.trim($("#hidden-company").val()));
		$("#search-mphone").val($.trim($("#hidden-mphone").val()));
		$("#search-source").val($.trim($("#hidden-source").val()));
		$("#search-owner").val($.trim($("#hidden-owner").val()));
		$("#search-phone").val($.trim($("#hidden-phone").val()));
		$("#search-state").val($.trim($("#hidden-state").val()));

		//?????????????????????????????????
		$.ajax({
			url : "workbench/clue/cluePageList.do",
			type : "get",
			dataType : "json",
			data : {
				"name" : $.trim($("#search-name").val()),
				"company" : $.trim($("#search-company").val()),
				"mphone" : $.trim($("#search-mphone").val()),
				"source" : $.trim($("#search-source").val()),
				"owner" : $.trim($("#search-owner").val()),
				"phone" : $.trim($("#search-phone").val()),
				"state" : $.trim($("#search-state").val()),
				"pageNo" : pageNo,
				"pageSize" : pageSize
			},
			success : function (data){
				//?????????data??????json
				var html = "";
				$.each(data.dataList,function (i,n){
					// alert("id???" + n.id)
					html += '<tr>';
					html += '<td><input type="checkbox" name="xz" value="' + n.id + '"/></td>';
					// html += '<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/clue/detail.do?id=' + n.id + '\';">' +n.name +'</a></td>';
					html += '<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/clue/detail.jsp;">' + n.fullname + n.appellation +'</a></td>';
					html += '<td>'+n.company+'</td>';
					html += '<td>'+n.phone+'</td>';
					html += '<td>'+n.mphone+'</td>';
					html += '<td>'+n.source+'</td>';
					html += '<td>'+n.owner+'</td>';
					html += '<td>'+n.state+'</td>';
					html += '</tr>';
				})
				$("#ClueBody").html(html);


				var totalPages = data.total%pageSize == 0 ? data.total/pageSize : parseInt(data.total/pageSize)+1;

				$("#cluePage").bs_pagination({
					currentPage: pageNo, // ??????
					rowsPerPage: pageSize, // ???????????????????????????
					maxRowsPerPage: 20, // ?????????????????????????????????
					totalPages: totalPages, // ?????????
					totalRows: data.total, // ???????????????

					visiblePageLinks: 3, // ??????????????????

					showGoToPage: true,
					showRowsPerPage: true,
					showRowsInfo: true,
					showRowsDefaultInfo: true,

					//???????????????????????????????????????????????????
					onChangePage : function(event, data){
						cluePageList(data.currentPage , data.rowsPerPage);
					}
				});
			}
		})
	}

	
</script>
</head>
<body>

	<!--?????????????????????????????????????????????????????????-->
	<input type="hidden" id="hidden-name">
	<input type="hidden" id="hidden-company">
	<input type="hidden" id="hidden-mphone">
	<input type="hidden" id="hidden-source">
	<input type="hidden" id="hidden-owner">
	<input type="hidden" id="hidden-phone">
	<input type="hidden" id="hidden-state">
	<!-- ??????????????????????????? -->
	<div class="modal fade" id="createClueModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">??</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">????????????</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="create-owner" class="col-sm-2 control-label">?????????<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-owner">
								<%--  <option>zhangsan</option>--%>
								<%--  <option>lisi</option>--%>
								<%--  <option>wangwu</option>--%>
								</select>
							</div>
							<label for="create-company" class="col-sm-2 control-label">??????<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-company">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-appellation" class="col-sm-2 control-label">??????</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-appellation">
								  <option></option>
								  <option value="??????">??????</option>
								  <option value="??????">??????</option>
								  <option value="??????">??????</option>
								  <option value="??????">??????</option>
								  <option value="??????">??????</option>
								</select>
							</div>
							<label for="create-fullname" class="col-sm-2 control-label">??????<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-fullname">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-job" class="col-sm-2 control-label">??????</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-job">
							</div>
							<label for="create-email" class="col-sm-2 control-label">??????</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-email">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-phone" class="col-sm-2 control-label">????????????</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-phone">
							</div>
							<label for="create-website" class="col-sm-2 control-label">????????????</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-website">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-mphone" class="col-sm-2 control-label">??????</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-mphone">
							</div>
							<label for="create-state" class="col-sm-2 control-label">????????????</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-state">
								  <option></option>
								  <option value="????????????">????????????</option>
								  <option value="????????????">????????????</option>
								  <option value="?????????">?????????</option>
								  <option value="????????????">????????????</option>
								  <option value="????????????">????????????</option>
								  <option value="?????????">?????????</option>
								  <option value="????????????">????????????</option>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-source" class="col-sm-2 control-label">????????????</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-source">
								  <option></option>
								  <option value="??????">??????</option>
								  <option value="????????????">????????????</option>
								  <option value="????????????">????????????</option>
								  <option value="????????????">????????????</option>
								  <option value="????????????">????????????</option>
								  <option value="????????????">????????????</option>
								  <option value="????????????">????????????</option>
								  <option value="????????????">????????????</option>
								  <option value="?????????????????????">?????????????????????</option>
								  <option>???????????????</option>
								  <option>?????????</option>
								  <option>web??????</option>
								  <option>web??????</option>
								  <option>??????</option>
								</select>
							</div>
						</div>
						

						<div class="form-group">
							<label for="create-description" class="col-sm-2 control-label">????????????</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-description"></textarea>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>
						
						<div style="position: relative;top: 15px;">
							<div class="form-group">
								<label for="create-contactSummary" class="col-sm-2 control-label">????????????</label>
								<div class="col-sm-10" style="width: 81%;">
									<textarea class="form-control" rows="3" id="create-contactSummary"></textarea>
								</div>
							</div>
							<div class="form-group">
								<label for="create-nextContactTime" class="col-sm-2 control-label">??????????????????</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control" id="create-nextContactTime">
								</div>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>
						
						<div style="position: relative;top: 20px;">
							<div class="form-group">
                                <label for="create-address" class="col-sm-2 control-label">????????????</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="create-address"></textarea>
                                </div>
							</div>
						</div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">??????</button>
					<button type="button" class="btn btn-primary" data-dismiss="modal" id="saveBtn">??????</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- ??????????????????????????? -->
	<div class="modal fade" id="editClueModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">??</span>
					</button>
					<h4 class="modal-title">????????????</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">

						<input type="hidden" id="edit-id" />

						<div class="form-group">
							<label for="edit-owner" class="col-sm-2 control-label">?????????<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-owner">
								  <option>zhangsan</option>
								  <option>lisi</option>
								  <option>wangwu</option>
								</select>
							</div>
							<label for="edit-company" class="col-sm-2 control-label">??????<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-company" value="????????????">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-appellation" class="col-sm-2 control-label">??????</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-appellation">
								  <option></option>
								  <option selected>??????</option>
								  <option>??????</option>
								  <option>??????</option>
								  <option>??????</option>
								  <option>??????</option>
								</select>
							</div>
							<label for="edit-fullname" class="col-sm-2 control-label">??????<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-fullname" value="??????">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-job" class="col-sm-2 control-label">??????</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-job" value="CTO">
							</div>
							<label for="edit-email" class="col-sm-2 control-label">??????</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-email" value="lisi@bjpowernode.com">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-phone" class="col-sm-2 control-label">????????????</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-phone" value="010-84846003">
							</div>
							<label for="edit-website" class="col-sm-2 control-label">????????????</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-website" value="http://www.bjpowernode.com">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-mphone" class="col-sm-2 control-label">??????</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-mphone" value="12345678901">
							</div>
							<label for="edit-state" class="col-sm-2 control-label">????????????</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-state">
								  <option></option>
								  <option>????????????</option>
								  <option>????????????</option>
								  <option selected>?????????</option>
								  <option>????????????</option>
								  <option>????????????</option>
								  <option>?????????</option>
								  <option>????????????</option>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-source" class="col-sm-2 control-label">????????????</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-source">
								  <option></option>
								  <option selected>??????</option>
								  <option>????????????</option>
								  <option>????????????</option>
								  <option>????????????</option>
								  <option>????????????</option>
								  <option>????????????</option>
								  <option>????????????</option>
								  <option>????????????</option>
								  <option>?????????????????????</option>
								  <option>???????????????</option>
								  <option>?????????</option>
								  <option>web??????</option>
								  <option>web??????</option>
								  <option>??????</option>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-description" class="col-sm-2 control-label">??????</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-description">?????????????????????????????????</textarea>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>
						
						<div style="position: relative;top: 15px;">
							<div class="form-group">
								<label for="edit-contactSummary" class="col-sm-2 control-label">????????????</label>
								<div class="col-sm-10" style="width: 81%;">
									<textarea class="form-control" rows="3" id="edit-contactSummary">???????????????????????????</textarea>
								</div>
							</div>
							<div class="form-group">
								<label for="edit-nextContactTime" class="col-sm-2 control-label">??????????????????</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control" id="edit-nextContactTime" value="2017-05-01">
								</div>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="edit-address" class="col-sm-2 control-label">????????????</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="edit-address">??????????????????????????????</textarea>
                                </div>
                            </div>
                        </div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">??????</button>
					<button type="button" id="updateBtn" class="btn btn-primary" data-dismiss="modal">??????</button>
				</div>
			</div>
		</div>
	</div>
	

	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>????????????</h3>
			</div>
		</div>
	</div>
	
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
	
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">??????</div>
				      <input class="form-control" id="search-name" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">??????</div>
				      <input class="form-control" id="search-company" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">????????????</div>
				      <input class="form-control" id="search-mphone" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">????????????</div>
					  <select class="form-control" id="search-source">
					  	  <option></option>
					  	  <option>??????</option>
						  <option>????????????</option>
						  <option>????????????</option>
						  <option>????????????</option>
						  <option>????????????</option>
						  <option>????????????</option>
						  <option>????????????</option>
						  <option>????????????</option>
						  <option>?????????????????????</option>
						  <option>???????????????</option>
						  <option>?????????</option>
						  <option>web??????</option>
						  <option>web??????</option>
						  <option>??????</option>
					  </select>
				    </div>
				  </div>
				  
				  <br>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">?????????</div>
				      <input class="form-control" id="search-owner" type="text">
				    </div>
				  </div>
				  
				  
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">??????</div>
				      <input class="form-control" id="search-phone" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">????????????</div>
					  <select class="form-control" id="search-state">
					  	<option></option>
					  	<option>????????????</option>
					  	<option>????????????</option>
					  	<option>?????????</option>
					  	<option>????????????</option>
					  	<option>????????????</option>
					  	<option>?????????</option>
					  	<option>????????????</option>
					  </select>
				    </div>
				  </div>

				  <button type="button" id="searchBtn" class="btn btn-default">??????</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 40px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" id="addBtn" ><span class="glyphicon glyphicon-plus"></span> ??????</button>
				  <button type="button" class="btn btn-default" id="editBtn" ><span class="glyphicon glyphicon-pencil"></span> ??????</button>
				  <button type="button" class="btn btn-danger" id="deleteBtn"><span class="glyphicon glyphicon-minus"></span> ??????</button>
				</div>
				
				
			</div>
			<div style="position: relative;top: 50px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="qx" /></td>
							<td>??????</td>
							<td>??????</td>
							<td>????????????</td>
							<td>??????</td>
							<td>????????????</td>
							<td>?????????</td>
							<td>????????????</td>
						</tr>
					</thead>
					<tbody id="ClueBody">

						<tr>
							<td><input type="checkbox" /></td>
							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='workbench/clue/detail.jsp';">????????????</a></td>
							<td>????????????</td>
							<td>010-84846003</td>
							<td>12345678901</td>
							<td>??????</td>
							<td>zhangsan</td>
							<td>?????????</td>
						</tr>
                        <tr class="active">
                            <td><input type="checkbox" /></td>
                            <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='workbench/clue/detail.jsp';">????????????</a></td>
                            <td>????????????</td>
                            <td>010-84846003</td>
                            <td>12345678901</td>
                            <td>??????</td>
                            <td>zhangsan</td>
                            <td>?????????</td>
                        </tr>
					</tbody>
				</table>
			</div>


			<div style="height: 50px; position: relative;top: 30px;">
				<div id="cluePage"></div>
			</div>

		</div>
		
	</div>
</body>
</html>