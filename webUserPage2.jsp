<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE HTML>
<html>
<head>
	<link rel="stylesheet" type="text/css" href="/resources/back/css/form.css" />
	<link rel="stylesheet" type="text/css" href="/resources/back/css/style.css" />
	<link rel="stylesheet" type="text/css" href="/resources/back/css/tooltip.css" />
	
	<script type="text/javascript" src="/resources/back/js/common_util.js"></script>	
	<link rel="stylesheet" type="text/css" href="/resources/back/js/timepicker/jquery.timepicker.min.css" />
	<script type='text/javascript' src="/resources/back/js/timepicker/jquery.timepicker.min.js"></script>
</head>
<body>
<!-- 전체 외곽박스 -->
<div class="basicBox">
<h1>관리자페이지 <label> / 계정관리</label></h1>
	<!-- 검색박스 -->
	<div class="searchBox">
		<table>
			<tr>
				<td class="title">검색조건</td>
				<td>
					<select  id="company" class="w-md select2class">
						<option value="0" company_idx="0">회사전체</option>
						<c:forEach var="i" items="${companyList}">
							<option value="${i.company}" company_idx="${i.idx}">${i.company_name}</option>
						</c:forEach>
					</select>
				</td>
				<td>
					<input type="text" id="search_keyword" class="input w-lg" value="">
				</td>
			</tr>
		</table>
		<!-- 버튼박스 -->
		<div class="SearchBtBox">
			<ul>
				<li><button type="button" class="button lightgray medium" id="btnSearch">검색</button></li>
				<li><button type="button" class="button green medium"  id="btnExcel">엑셀</button></li>
			</ul>
		</div>
	</div>
	<!-- 양쪽box -->
	<div style="margin-top: 20px">
		<ul class="group">
			<li class="grid-lt" style="width:65%">
			<!-- 그리드 -->
				<div class="gbox" id="gbox">
					<table id="grid_list_1"></table>
					<div id="grid_list_page_1"></div>
				</div>
			</li>
			<li class="grid-rt"  style="width:33%;">
			<div class="left-box-630h">
				<div  id="request_btnBox" class="left-box-btn"> 
					<ul class="group">
						<li class="grid-lt"><h2>회원정보</h2></li>
						<li class="grid-rt">
							<button type="button" class="button blue medium" id="btnDupCheck">중복체크</button>
							<button type="button" class="button blue medium" id="btnNew">신규</button>
							<button type="button" class="button orange medium" id="btnSave">저장</button>
							<button type="button" class="button gray medium"  id="btnDel">삭제</button>
						</li>
					</ul>
				</div>
				<div class="gbox view">
					<!-- ********************************************************************************************************* -->
				<!-- 입력폼 -->
				<form id="userDetailForm">
				<input type="hidden" id="tb_idx" maxlength="">
				<table class="listBox-common">
					<tr>
						<td class="title">회사명 <label>*</label></td>
						<td>
							<select id="tb_company" class="select2class w-md-select">
								<c:forEach var="i" items="${companyList}">
									<option value="${i.company}" company_idx="${i.idx}">${i.company_name}</option>
								</c:forEach>
							</select>
						</td>
					</tr>
					<tr>
						<td class="title" style="display: none;">시나리오관리자 </td>
						<td style="display: none;">
							<select class="select2class w-md-select" id="t_web_user">
								<option value="N" selected="selected">미사용</option>
								<option value="Y">사용</option>
							</select>
						</td>
					</tr>
					<tr>
						<td class="title rcc_dn_logoff_class" style="display: none;">CTI 강제 로그오프</td>
						<td class="rcc_dn_logoff_class" style="display: none;"><button type="button" class="button green medium" id="btnCtiLogoff">실행</button></td>
					</tr>
					<tr>
						<td class="title">아이디 <label>*</label></td>
						<td>
							<input type="text" id="tb_userid" maxlength="20" class="w-md input">
						</td>
					</tr>
					<tr>
						<td class="title">이름 <label>*</label></td>
						<td>
							<input type="text" id="tb_username" maxlength="30" class="w-md input">
						</td>
					</tr>
					<tr>
						<td class="title">모바일 <label>*</label> </td>
						<td>
							<input type="text" id="tb_mobile" class="onlyNumber w-md input" maxlength="30">
						</td>
					</tr>
					<tr style="display: none;">
						<td class="title">직급</td>
						<td>
							<input type="text" id="tb_grade" maxlength="30"  class="w-md input">
						</td>
					</tr>
					<tr  style="display: none;">
						<td class="title">SMS</td>
						<td>
							<input type="text" id="t_sms_dn" maxlength="30"  class="w-md input">
						</td>
					</tr>
					<tr>
						<td class="title">회원권한 <label>*</label></td>
						<td>
							<select class="select2class w-md-select" id="t_admin_yn"></select>
						</td>
					</tr>
					<tr class="admin_role_view" style="display: none;">
						<td style="text-align: center;">
							추가 권한
						</td>
						<td>
							<select class="select2class w-md-select" id="t_admin_role">
								<option value="0" selected="selected">미사용</option>
								<option value="1">사용</option>
							</select>
						</td>
						<td>
							<div class="tip">
								?
								<div class="tip-popup">
									<div class="tp-section">
										<div class="tp-category">회사 설정</div>
										<ul class="tp-list">
											<li>ACS TOKEN (api 관련) 설정</li>
											<li>녹취대량다운로드 설정</li>
											<li>(로그인 서버) 회사 수정</li>
											<li>(로그인 서버) 선/후불 설정</li>
											<li>(로그인 서버) 로그인 서버 지정</li>
											<li>(로그인 서버) 연령별인구현황 크롤링</li>
										</ul>
									</div>
									<div class="tp-section">
										<div class="tp-category">캠페인 설정</div>
										<ul class="tp-list">
											<li>과금 번호 선택</li>
											<li>대기 상태 이외의 캠페인 삭제 (진행중 제외)</li>
										</ul>
									</div>
									<div class="tp-section">
										<div class="tp-category">기타</div>
										<ul class="tp-list">
											<li>채널 모니터링 팝업</li>
										</ul>
									</div>
								</div>
							</div>
						</td>
					</tr>
					<tr>
						<td class="title">비밀번호 <label>*</label></td>
						<td>
							<input type="password" id="t_pswd" maxlength="256" class="w-md input">
							<button type="button" class="button white medium" id="btnPswdChange" style="display:none;">변경</button>
							<input type="password" id="old_pswd" maxlength="256" class="w-md input" style="display:none;">
						</td>
					</tr>
					<tr>
						<td class="title">로그인 오류 횟수</td>
						<td>
							<input type="text" id="t_blocked" disabled="disabled" class="w-md input">
							<button type="button" class="button white medium" id="btnBlockedInit">초기화</button>
						</td>
					</tr>
					<tr  style="display: none;">
						<td class="title">전화번호</td>
						<td>
							<input type="text" id="t_rcc_dn" class="onlyNumber w-md input" maxlength="30">
							<input type="hidden" id="t_private_id" class="onlyNumber" maxlength="30">
						</td>
					</tr>
					<tr  style="display: none;">
						<td class="title">ACD후처리시간</td>
						<td>
							<input type="text" id="tb_wrapup_time" class="onlyNumber w-md input" value="2" maxlength="4">
						</td>
					</tr>
					<tr  style="display: none;">
						<td class="title">자동저장 설정</td>
						<td>
							<select class="select2class w-md-select" id="tb_auto_working_aftercall">
								<option value="0">사용안함</option>
								<option value="1">사용함</option>
							</select>
						</td>
					</tr>
					<tr  style="display: none;">
						<td class="title">콜백조회권한</td>
						<td>
							<select class="select2class w-md-select" id="tb_cb_permission">
								<option value="0">없음</option>
								<option value="1">있음</option>
							</select>
						</td>
					</tr>
				</table>
				</form>
				<!-- ********************************************************************************************************* -->
				</div>
				</div>
			</li>
		</ul>
	</div>
</div>
<script>
var curRowId = -1;//그리드에서 현재 선택한 로우
//var SELECT_COMPANY='';//그리드용 회사 코드
var groupsList=[];//부서 콤보박스 데이터

$(document).ready(function() {
	init();//초기화
	initGrid();//그리드 초기화
	
	//검색조건-회사
	$('#company').change(function(event) {
		event.preventDefault();
		fnGroupsComboSet('searchBox', '', $('#company option:selected').attr('company_idx'));
	});
	
	// 엔터 검색 처리
	$('#search_keyword').keydown(function(key) {
		if(key.keyCode == 13) {
			$('#btnSearch').click();
		}
	});
	
	//조회 버튼
	$('#btnSearch').click(function(event){
		event.preventDefault();
		curRowId = -1;
		
		$('#btnNew').click();//초기화
		GridLoad();
	}).click();
	
	//엑셀 버튼
	$('#btnExcel').click(function(event) {
		event.preventDefault();
		
		$('#circularG').show();
		$.ajax({
			dataType : 'json',
			url : '/member/getMemberFileExcel.do',
			method : 'post',
			data : getParam(),
			success : function(data) {
				if('success' == data.returnRst) {
					$('body').append('<form name="fileDownloadForm" id="fileDownloadForm" method="post"></form>');
					$('#fileDownloadForm').append('<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">');
					$('#fileDownloadForm').append('<input type="hidden" name="filename" value="'+data.fileName+'">');
					document.fileDownloadForm.action = "/common/Exceldown.do";
					document.fileDownloadForm.submit();
					$('#fileDownloadForm').remove();
				} else {
					$.common.alert(data.returnMsg, '');
				}
				$('#circularG').hide();
			},error : function(data) {
				$.common.alert(data, '');
				$('#circularG').hide();
			}
		});
	});
	
	//신규 버튼
	$('#btnNew').click(function(event){
		event.preventDefault();

		$('#tb_userid').prop('disabled', false);//아이디
		$('#tb_company').prop('disabled', false);//회사명
		$('#tb_idx').val('');
		$('#userDetailForm')[0].reset();
		// 비밀번호 변경 버튼, 로그인 오류 횟수 초기화 버튼, CTI 강제 로그오프 버튼 숨김
		$("#btnPswdChange, #btnBlockedInit, .rcc_dn_logoff_class").hide();
		// 비밀번호, 로그인 오류 횟수 입력 input 사이즈 조정
		$("#t_pswd, #t_blocked").width("168px");
		$("#btnDupCheck").show();
		
		fnGroupsComboSet('view', '', $('#tb_company option:selected').attr('company_idx'));
	}).click();
	
	//저장 버튼
	$('#btnSave').click(function(event){
		event.preventDefault();

		fnSave();
	});
	
	//삭제 버튼
	$('#btnDel').click(function(event){
		event.preventDefault();

		fnDel();
	});
	
	//중복체크 버튼 : 아이디/내선/RCC DN
	$('#btnDupCheck').click(function(event){
		event.preventDefault();
		fnDupCheckInfos('all');
	});
	
	//회원권한(사용안함)
	$('#t_admin_yn').change(function(event){
		event.preventDefault();
		
		if ('${sessionScope.admin_yn}' == "9999999" && event.target.value == '9999998') {
			$(".admin_role_view").show();
		} else {
			$(".admin_role_view").hide();
		}
	});
	
	//상세 페이지 비밀번호 오류 횟수 초기화 버튼
	$('#btnBlockedInit').click(function(event) {
		event.preventDefault();
		var rowData = $('#grid_list_1').getRowData(curRowId);

		fnUnblock(rowData.userid);
	});
	
	//비밀번호 변경
	$('#btnPswdChange').click(function(event) {
		event.preventDefault();

		fnPswdChange();
	});
	
	//CTI 강제 로그오프
	$('#btnCtiLogoff').click(function(event) {
		event.preventDefault();

		if($("#t_rcc_dn").val() == '' || $("#t_rcc_dn").val() == undefined || $("#t_rcc_dn").val() == null) {
			$.common.alert('CTI 강제 로그오프는 전화번호가 있는 경우만 실행 가능 합니다.', '');
			return;
		}

		fnCtiLogoff();
	});
	
	//부서 버튼 선택
	$('body').on('change', 'tr.groupClass select.select2class', function(event){
		event.preventDefault();
		
		var position = $(this).parents('table').closest('div').attr('class');
		var company_idx = $(this).find('option:selected').attr('company_idx');
		fnGroupsComboSet(position, $(this).val(), company_idx);
	});

	$('#t_admin_yn').initSelect2( //회원권한
		'/codeManage/getSysCodeAdminRoleList.do', // getSysCodeAdminYnCboList
		{ "code_gb":"USRLV",
		  "company_idx":$('#tb_company option:selected').attr("company_idx"),
		  "page_gb":"WEB"
		},
		null,
		function() { $('#t_admin_yn').select2('val', t_user.admin_yn).change(); }
	);
});

//그리드 설정
function initGrid(){
	//grid 초기화
	var options1 = {};
	options1.type = 'CheckOne'; //그리드 유형
	options1.parentDiv = '#gbox';
	options1.pager = '#grid_list_page_1'; //페이저 아이디
	options1.caption = '회원관리 (관리자 계정)';
	options1.rownumbers = true;
	options1.rowNum = 20;
	options1.rowList = [20,30,50,100];
	options1.sortname = 'username';
	options1.sortorder = 'asc';
	options1.height = '455px';
	options1.shrinkToFit = true;
	options1.autoColumnResize = false; 
	options1.names = [
		'idx',
		'아이디',
		'이름',
		'회사index',
		'회사명',
		'회사',
		'직급',
		'부서',
		'회원권한(코드)',
		'회원권한',
		'내선',
		'전화번호',
		'SMS',
		'모바일' 
	];
	options1.colModels = [
		{ name:'idx',			index:'idx',			align:'right',	width:'50',		editable:false,	sortable:false,	hidden:true},
		{ name:'userid',		index:'userid',			align:'left',	width:'100',	editable:false,	sortable:false},
		{ name:'username',		index:'username',		align:'left',	width:'100',	editable:false,	sortable:false},
		{ name:'company_idx',	index:'company_idx',	align:'center',	width:'50',		editable:false,	sortable:false,	hidden:true},
		{ name:'company_name',	index:'company_name',	align:'left',	width:'80',		editable:false,	sortable:false},
		{ name:'company',		index:'company',		align:'center',	width:'60',		editable:false,	sortable:false,	hidden:true},
		{ name:'grade',			index:'grade',			align:'center',	width:'50',		editable:false,	sortable:false, hidden:true},
		{ name:'groups',		index:'groups',			align:'left',	width:'100',	editable:false,	sortable:false, hidden:true,	
			formatter:format_groups
		},
		{ name:'admin_yn',		index:'admin_yn',		align:'center',	width:'50',		editable:false,	sortable:false, hidden:true
			// formatter:'select', edittype:'select', editoptions:{value:'0:상담원;1:고객관리자;2:슈퍼관리자;'}
		},
		{ name:'auth_name',		index:'auth_name',		align:'center',	width:'50',		editable:false,	sortable:false},
		{ name:'private_id',	index:'private_id',		align:'center',	width:'50',		editable:false,	sortable:false, hidden:true},
		{ name:'rcc_dn',		index:'rcc_dn',			align:'center',	width:'70',		editable:false,	sortable:false, hidden:true},
		{ name:'sms_dn',		index:'sms_dn',			align:'center',	width:'70',		editable:false,	sortable:false, hidden:true},
		{ name:'mobile',		index:'mobile',			align:'center',	width:'70',		editable:false,	sortable:false}
	];
	
	//json 데이터를 읽는 방법 지정
	options1.jsonReaders = {
		resultSuccess : function(obj) {
			if ("FAIL" == obj) alert("Data Load Fail");
		},
		root : "root", // ListData Root
		page : "page", // Current Page
		total : "total", // Total Pages
		records : "records", // Total Records
		repeatitems : false
	};
	options1.navGridButton = { add : false, edit : false, del :false , search : false, refresh : false };
	options1.onSelectRow = function( id ) {
		if(id && id !== curRowId){
			if(curRowId == -1) {
				$('#grid_list_1').jqGrid('saveRow',curRowId,true);
				$('#grid_list_1').jqGrid('editRow',id,true);
				curRowId = id;
			} else if(curRowId != -1) {
				curRowId = id;
			}
		}

		// 중복 검색 제외
		if($('#circularG').is(':visible')) {
			return false;
		}
		
		//현재 선택된 사용자 정보
		selectMemberInfo();
		
		$('select.editable').select2('destroy');
		$('select.editable').select2({width : '100%'});
	}
	options1.gridComplete = function() {
		fnReSelect2();
	}
	options1.loadComplete = function() {
		$("tr.ui-priority-secondary").removeClass('ui-widget-content').removeClass("ui-priority-secondary").addClass('skyAltRowClass');	//CSS Style
	}
	
	$('#grid_list_1').skyGrid(options1);
}

function init(){
	//숫자만 입력
	$('body').on('keyup', '.onlyNumber', function(event){
		event.preventDefault();
		this.value = this.value.replace(/[^0-9]/g,'');
	});

	// 비밀번호 변경 버튼, 로그인 오류 횟수 초기화 버튼, CTI 강제 로그오프 버튼 숨김
	$("#btnPswdChange, #btnBlockedInit, .rcc_dn_logoff_class, #btnDupCheck").hide();
	 
	fnGroupsList($('#tb_company option:selected').attr('company_idx'));

	$('.auth_hidden_field').hide();
}

function fnSaveResultApi(param){
	$('#circularG').show();
	$.ajax({
		dataType : 'json',
		url : '/member/saveMemberInfo.do',
		type :'post',
		data : param,
		crossDomain	: true,
		success : function(data) {
			if(data.returnRst == 'success') {
				$.common.alert('저장이 완료되었습니다.', function(){
					$('#btnNew').click();//초기화
					GridLoad();
				});
			} else {
				$.common.alert(data.returnMsg, '');
			}
		},error : function(error) {
			$.common.alert(error);
		},complete : function () {
			$('#circularG').hide();
		}
	});
}

//저장 버튼 클릭
function fnSave(){
	if(validation()) {
		$.common.confirm( '저장 하시겠습니까?' , function(bool) {
			if(!bool) return;
			
			$('#circularG').show();
			var agent_num = $.trim($('#t_rcc_dn').val());
			var param = {
				'work_gb'		: $('#tb_userid').is(":disabled") ? "U" : "I",			// U:수정작업, I:저장작업
				'user_id'		: $.trim($('#tb_userid').val()),						// 사용자ID
				'password'		: $.trim($('#t_pswd').val()),							// 비밀번호
				'extension'		: agent_num,											// 내선(EXT)
				'ext'			: agent_num,											// 내선(EXT)
				'rcc_dn'		: agent_num,											// RCC DN(VOIP)
				'sms_dn' 		: $.trim($('#t_sms_dn').val()),
				'mobile'		: $.trim($('#tb_mobile').val()),
				'company_idx'	: $('#tb_company option:selected').attr("company_idx"),
				'group_id'		: $('#tb_company option:selected').val(),				// 회사
				'admin_yn'		: $('#t_admin_yn option:selected').val(),				// 회원권한
				'admin_role'	: $('#t_admin_role option:selected').val(),				// 추가권한
				'username'		: $.trim($('#tb_username').val()),						// 회원이름
				'groups'		: $('div.view #groups_view_'+($('div.view tr.groupClass select.select2class').length-1)+' option:selected').val(), // 부서
				'grade'			: $.trim($('#tb_grade').val()),							// 직급
				'wrapup_time'	: '2',	// ACD후처리시간 - Default
				'cb_permission'	: '1'	// 콜백조회권한 - Default
			};
			
			if($.trim($('#tb_idx').val()) == '') {
				//##################################################
				//저장 insert 시작
				param['url'] = 'post/sign_up.json';
				param['method'] = 'POST';
				
				$.ajax({
					type : 'POST',
					url : '/member/saveRequestAPI.do',
					data : param,
					crossDomain : true,
					dataType : 'json',
					success : function(result) {
						//작업이력 저장 ##########
						insertJobLog(this, param, result, 'WEB_USER');
						
						if(result.code == '200') {
							fnSaveResultApi({
								'user_id' : param.user_id,
								'admin_role' : param.admin_role
							});
						} else {
							$.common.alert(result.result, '');
						}
					},
					error:function(error) {
						$.common.alert('회원 정보 등록에 실패하였습니다.', '');
					}
				});
				//저장 insert 종료
				//##################################################
			} else {//수정
				//##################################################
				//저장 update 시작
				param['url'] = 'post/change_etc_profile.json';
				param['method'] = 'PUT';

				$.ajax({
					dataType : 'json',
					url : '/member/saveRequestAPI.do',
					data : param,
					type : 'POST',
					crossDomain : true,
					success : function(result) {
						//작업이력 저장 ##########
						insertJobLog(this, param, result, 'WEB_USER');
						
						if(result.code == '200') {
							fnSaveResultApi({
								'user_id' : param.user_id,
								'admin_role' : param.admin_role
							});
						} else {
							$.common.alert(result.result, '');
						}
					},
					error : function(error) {
						$.common.alert('회원 정보 수정에 실패하였습니다.', '');
					}
				});
				//저장 update 종료
				//##################################################
			}
			$('#circularG').hide();
		});
	}
}

//삭제 버튼 클릭
function fnDel(){
	var chkidxs = $('#grid_list_1').jqGrid('getGridParam','selarrrow');
	if(chkidxs.length < 1) {
		$.common.alert('삭제할 대상을 선택해 주시기 바랍니다.', '');
		return false;
	}
	
	$.common.confirm('선택한 대상을 삭제하시겠습니까?', function(bool) {
		if(!bool) return false;

		var paramObj = new Object();
		var paramArray = new Array();
		
		var delList = [];
		for (var i = 0; i < chkidxs.length; i++) {
			var user_ids = $('#grid_list_1').jqGrid('getCell', chkidxs[i], 'userid');
			delList.push(user_ids);
			
			var company = $('#grid_list_1').jqGrid('getCell', chkidxs[i], 'company');
			var company_idx = $('#grid_list_1').jqGrid('getCell', chkidxs[i], 'company_idx');
			
			paramObj = new Object(); 
			paramObj['user_id'] = user_ids;
			paramObj['company'] = company;
			paramObj['company_idx'] = company_idx;
			paramArray.push(paramObj);
		}
		
		var param = {
			'userids'	: delList.toString(),
			'data' 		: JSON.stringify(paramArray)
		};
		
		$('#circularG').show();
		$.ajax({
			datatype		: 'json',
			type				: 'post',
			method			: 'post',
			url					: '/member/deleteMemberInfo.do',
			data				: param,
			crossDomain	: true,
			success			: function(data) {
				//작업이력 저장
				insertJobLog(this, param, data, 'WEB_USER');

				$('#circularG').hide();
				if (data.returnRst == "success") {
					$.common.alert('작업이 완료 되었습니다.', '');
					$('#btnNew').click();//초기화
					GridLoad();
				} else {
					$.common.alert(data.returnMsg, '');
				}
			},
			error : function() {
				$('#circularG').hide();
				$.common.alert(data.returnMsg);
			}
		});
	});
}

//CTI 강제 로그오프 클릭
function fnCtiLogoff(){
	$.common.confirm('CTI 강제 로그오프를 실행하시겠습니까?', function(bool) {
		if(bool) {
			var param = {
				'url' : 'reset_agent_status.json',
				'userid' : $('#tb_userid').val()
			};
			$.ajax({
				url : '/member/setCtiLogOffAPI.do',
				type : 'POST',
				dataType : 'json',
				crossDomain : true,
				data : param,
				success:function(result) {
					//작업이력 저장 ##########
					insertJobLog(this, param, result, 'WEB_USER');
					
					if(result.result == 'ok') {
						$.common.alert('CTI 강제 로그오프 되었습니다.', '');
					} else {
						$.common.alert('CTI 강제 로그오프에 실패 하였습니다.', '');
					}
				},
				error:function(error) {
					$.common.alert('CTI 강제 로그오프 중 오류가 발생하였습니다.', '');
					console.log(error);
				}
			});
		}
	});
}

//select2 재구성
function fnReSelect2(){
	$('.select2class').select2('destroy');
	$('.select2class').select2();
}

//그리드 부서
function format_groups(cellvalue, options, rowObject){
	var str = '';
	if(cellvalue != '' && cellvalue != null && cellvalue != undefined) {
		str = cellvalue.replace(/\|/gi, ' > ');
	}
	return str;
}

//비밀번호 변경
function fnPswdChange(){
	$.common.confirm('비밀번호를 수정 하시겠습니까?', function(bool) {
		if(!bool) return false;
		
		if(checkPasswordExclusionCharactor($('#t_pswd').val())) {
			$.common.alert(' 비밀번호를 다시 확인해주세요.', '');
			return false;
		}

		const param = {
			'url' : 'post/change_password.json',
			'method' : 'PUT',
			'user_id' : $('#tb_userid').val(),
			'new_password' : $('#t_pswd').val()
		};

		$.ajax({
			dataType : 'json',
			url : '/member/saveRequestAPI.do',
			data : param,
			type : 'POST',
			crossDomain : true,
			success : function(result) {
				//작업이력 저장 ##########
				param.new_password = param.new_password.replace(/./g,'*');
				insertJobLog(this, param, result, 'WEB_USER');
				
				if(result.result == 'ok') {
					GridLoad();
					selectMemberInfo();
					$.common.alert('비밀번호가 변경 되었습니다.', '');
				} else {
					$.common.alert(result.result, '');
				}
			},
			error : function(error) {
				$.common.alert('비밀번호 변경에 실패하였습니다.', '');
			}
		});
	});
}

//현재 선택된 사용자 정보
function selectMemberInfo(){
	$('#circularG').show();
	$('#btnNew').click();//초기화
	// 비밀번호, 로그인 오류 횟수 입력 input 사이즈 조정
	$("#t_pswd").width("93px");
	$("#t_blocked").width("82px");
	
	if(curRowId > 0){
		var rowData = $('#grid_list_1').getRowData(curRowId);
		var param = {
			'userid' : rowData.userid
		};

		$.ajax({
			dataType : 'json',
			url : '/member/selectMember.do',
			type :'post',
			data : param,
			success : function(data){
				var tb_user = data.tbUserInfo;
				var t_user = data.tUserInfo;

				$('#tb_company').select2('val', tb_user.company);//회사명
				$('#tb_company').prop('disabled', true);//회사명
				$('#t_admin_role').val(t_user.admin_role);//admin_role
				$('#tb_idx').val(tb_user.idx);//index
				$('#tb_username').val(tb_user.username);//이름
				$('#tb_userid').prop('disabled', true);//아이디
				$('#tb_userid').val(tb_user.userid);//아이디
				// $('#t_admin_yn').select2('val', t_user.admin_yn);//회원권한
				$('#t_pswd').val(t_user.pswd);//비밀번호
				$('#old_pswd').val(t_user.pswd);//비밀번호
				$("#btnPswdChange").show();
				$('#t_blocked').val(t_user.blocked);//비밀번호 오류 횟수
				$("#btnBlockedInit").show();
				$('#t_private_id').val(t_user.private_id);//extension, 내선
				$('#t_rcc_dn').val(t_user.rcc_dn);//VOIP
				$(".rcc_dn_logoff_class").hide();
				$('#tb_grade').val(tb_user.grade);//직급
				$('#t_sms_dn').val(t_user.sms_dn);//SMS_DN
				$('#tb_mobile').val(tb_user.mobile);//MOBILE
				
				$('#tb_wrapup_time').val(tb_user.wrapup_time);//ACD후처리시간
				$('#tb_auto_working_aftercall').select2('val', tb_user.auto_working_aftercall);//자동저장

				//부서
				fnGroupsComboSet('view', '', $('#tb_company option:selected').attr('company_idx'));//부서 콤보박스 조회
				if(tb_user.groups != undefined && tb_user.groups !=''){
					var groups = tb_user.groups.split('|');
					var groupValue = '';
					for(var idx=0; idx<groups.length; idx++){
						groupValue += (idx==0 ? '':'|')+groups[idx];
						$('div.view #groups_view_'+idx).select2('val', groupValue).change();
					}
				}

				$('#tb_cb_permission').select2('val', tb_user.cb_permission);//콜백조회권한
				$('#t_web_user').select2('val', t_user.web_user);//시나리오관리자
				
				$('#circularG').hide();//progress
			},
			error : function(){
				$('#circularG').hide();//progress
			}
		});
	}
	$("#btnDupCheck").hide();
}

function getParam(){
	var param = {
		'company' : $('#company option:selected').attr('company_idx'),
		'search_keyword' : $('#search_keyword').val()
	};
	return param;
}
function GridLoad() {
	$('#grid_list_1').jqGrid('setGridParam', {
		url: '/member/getMemberList.do',
		datatype : 'json',
		search: true,
		async: true,
		postData : getParam(),
		mtype : 'POST',
		page : 1
	}).trigger('reloadGrid',[{page:1}]);
}

//아이디 / 내선 / RCC DN 중복 체크
// type : all, userid, extension, rccdn
function fnDupCheckInfos(type){
	var param = {};
	param['userid'] = $('#tb_userid').val();
	param['extension'] = $('#t_rcc_dn').val();
	param['rcc_dn'] = $('#t_rcc_dn').val();
	param['check_type'] = type;

	var rtn = false;
	$.ajax({
		dataType : 'json',
		method : 'post',
		url : '/member/fnDupCheckInfos.do',
		async : false,
		data : param,
		success : function(result){
			var dup_check_txt = '[ 중복 확인 결과 ]<br>';
			if(type == 'all') {
				dup_check_txt += '아이디 중복 : ' + result.dup_id_count + ' 건<br>';
				dup_check_txt += '전화번호 중복 : ' + result.dup_ext_count + ' 건<br>';
				if(result.dup_id_count == 0 && result.dup_ext_count == 0 && result.dup_rcc_dn_count == 0) {
					rtn = true;
				} else {
					if(result.dup_id_count > 0) {
						dup_check_txt += '아이디 중복으로 등록 불가<br>';
					}
					if(result.dup_ext_count > 0 || result.dup_rcc_dn_count > 0) {
						dup_check_txt += '전화번호 중복으로 등록 불가<br>';
					}
				}
			} else if(type == 'userid') {
				dup_check_txt += '아이디 중복 : ' + result.dup_id_count + ' 건<br>';
				if(result.dup_id_count > 0) {
					dup_check_txt += '아이디 중복으로 등록 불가<br>';
				}
			} else if(type == 'extension') {
				dup_check_txt += '전화번호 중복 : ' + result.dup_ext_count + ' 건<br>';
				if(result.dup_ext_count > 0) {
					dup_check_txt += '전화번호 중복으로 등록 불가<br>';
				}
			}
			$.common.alert(dup_check_txt, '');
		},error : function(error){
			$.common.alert(error);
		}
	});
	return rtn;
}

function validation(){
	if($.trim($('#tb_company option:selected').val()) == '0') {
		$.common.alert('회사를 선택해 주시기 바랍니다.', '');
		return false;
	}
	if($.trim($('#tb_userid').val()) == '') {
		$.common.alert('아이디를 입력해 주시기 바랍니다.', '');
		return false;
	}
	let regexId = /^[a-z0-9]+$/;
	if (!regexId.test($('#tb_userid').val())) {
		$.common.alert('아이디는 영어와 숫자만 입력 가능합니다.', '');
		//$('#tb_userid').val($('#tb_userid').val().replace(/[^a-z0-9]/g, ''));
		return false;
	}
	if($.trim($('#tb_username').val()) == '') {
		$.common.alert('이름을 입력해 주시기 바랍니다.', '');
		return false;
	}
	if($.trim($('#t_pswd').val()) == '') {
		$.common.alert('비밀번호를 입력해 주시기 바랍니다.', '');
		return false;
	}
	if($.trim($('#t_admin_yn option:selected').val()) == '') {
		$.common.alert('회원권한을 선택해 주시기 바랍니다.', '');
		return false;
	}
	if($.trim($('#tb_mobile').val()) == '') {
		$.common.alert('Mobile 번호를 입력해 주시기 바랍니다.', '');
		return false;
	}
	return true;
}

//로그인 오류 횟수	 초기화
function fnUnblock(userid){
	if($('#tb_userid').val() == '' || $('#tb_userid').val() == undefined || $('#tb_userid').val() == null) {
		$.common.alert('초기화 대상을 회원 리스트에서 선택해 주시기 바랍니다.');
		return false;
	}

	var param = {
		'url' : 'reset_error_counter.json',
		'method' : 'PUT',
		'userid' : $('#tb_userid').val()
	};

	$.ajax({
		dataType : 'json',
		url : '/member/saveRequestAPI.do',
		data : param,
		type : 'POST',
		success : function(result){
			//작업이력 저장 ##########
			insertJobLog(this, param, result, 'WEB_USER');

			if(result.code == 200) {
				$.common.alert('로그인 오류 횟수 초기화하였습니다.', '');
				GridLoad();
				selectMemberInfo();
			} else {
				$.common.alert('로그인 오류 횟수에 실패하였습니다.', '');
			}
		}
	});
}

//부서 콤보박스 데이터 조회
function fnGroupsList(company_idx){
	$('#circularG').show();
	var param = {'company_key' : company_idx};
	$.ajax({
		dataType : 'json',
		url : '/group/getGroupOrganList.do',
		data : param,
		type : 'post',
		crossDomain : true,
		async : false,
		success : function(result) {
			groupsList = result.data;
		}
	});
	$('#circularG').hide();
}

//부서 콤보박스
var cur_combo_company_idx = 0;//부서 조회 중복 방지
function fnGroupsComboSet(position, key, company_idx){

	if(cur_combo_company_idx != company_idx){
		//이전에 조회했던 정보와 일치하지 않는 경우만 조회
		cur_combo_company_idx = company_idx;
		//부서 콤보박스 데이터 조회
		fnGroupsList(company_idx);
	}
	
	var groupsHtml = '';
	var groupsHtmlOption = '';
	var comboCnt = 0;
	
	
	var startTrRow = 0;//시작 로우
	var addTdCol = 0;//추가 td의 갯수
	var selectTdCol = 0;//콤보박스가 위치할 td의 위치
	if(position == 'view') {
		startTrRow = 3;
		addTdCol = 6;
		selectTdCol = 2;//2,4,6,8번째 td에 생성
	} else if(position == 'searchBox') {
		startTrRow = 2;
		addTdCol = 3;
		selectTdCol = 1;//1,2,3,4번째 td에 생성
	}
	
	//몇번째 콤보박스 인지 위치 확인
	for(var idx=0; idx<groupsList.length; idx++){
		if(key == groupsList[idx].organ_name) {
			comboCnt = groupsList[idx].cnt;
			comboCnt++;
			break;
		}
	}
	
	//현재 선택된 요소의 하위 부서는 모두 삭제
	if(comboCnt==0) $('div.'+position+' .groupClass').remove();//시작 부서의 경우 전체 삭제
	else {
		//tr 삭제
		for(var idx=$('div.'+position+' tr.groupClass').length; idx>0; idx--){
			if( idx > parseInt(comboCnt / 4) )
				$('div.'+position+' tr.groupClass').eq(idx).remove();
		}
		//select box 삭제
		for(var idx=$('div.'+position+' tr.groupClass select.select2class').length; idx>0; idx--){
			if(comboCnt > idx) break;
			
			$('div.'+position+' tr.groupClass select.select2class').eq(idx).remove();
		}
	}
	
	if(comboCnt%4 == 0) {//시작 부서 및 로우의 첫번째 부서
		groupsHtml += '<tr class="groupClass">\n'; 
		groupsHtml += '\t<td class="title">' + (comboCnt==0 ? '부서' : '') + '</td>\n';
		groupsHtml += '\t<td colspan="5">\n';
		groupsHtml += '\t\t<select class="select2class" id="groups_'+position+'_'+comboCnt+'" style="width:168px;">\n';
		groupsHtml += '\t\t\t<option value="'+key+'" company_idx="'+company_idx+'">' + (comboCnt==0 ? '' : (key.split('|')[key.split('|').length-1])+'하위 부서 ') + '선택</option>\n';
		
		for(var idx=0; idx<groupsList.length; idx++){
			if(comboCnt == groupsList[idx].cnt){
				if(key=='' || groupsList[idx].organ_name.indexOf(key+'|') == 0) {
					groupsHtmlOption += '\t\t\t<option value="'+groupsList[idx].organ_name+'" company_idx="'+company_idx+'">'+groupsList[idx].organ_name.replace(key+'|','')+'</option>\n';
				}
			}
		}
		
		if(groupsHtmlOption != ''){
			groupsHtml += groupsHtmlOption;
			groupsHtml += '\t\t</select>\n';
			groupsHtml += '\t</td>\n';
			
			//하위 부서 정보가 들어갈 TD 미리 생성
			for(var idx=0; idx<addTdCol; idx++) groupsHtml += '\t<td></td>\n';
			
			groupsHtml += '</tr>\n';
			
			// $('div.'+position+' table.newBox tr:eq('+(startTrRow + parseInt(comboCnt/4))+')').after(groupsHtml);
			$('div.'+position+' table.newBox tr:eq('+(startTrRow -1 + parseInt(comboCnt/4))+')').after(groupsHtml);
		}
	} else {//하위 부서
		groupsHtml += '\t\t<select class="select2class" id="groups_'+position+'_'+comboCnt+'" style="width:168px;">\n';
		groupsHtml += '\t\t\t<option value="'+key+'" company_idx="'+company_idx+'">' + (comboCnt==0 ? '' : (key.split('|')[key.split('|').length-1])+' 하위부서 ') + '선택</option>\n';
		
		for(var idx=0; idx<groupsList.length; idx++){
			if(comboCnt == groupsList[idx].cnt){
				if(groupsList[idx].organ_name.indexOf(key+'|') == 0) {
					groupsHtmlOption += '\t\t\t<option value="'+groupsList[idx].organ_name+'" company_idx="'+company_idx+'">'+groupsList[idx].organ_name.replace(key+'|','')+'</option>\n';
				}
			}
		}
		
		if(groupsHtmlOption != ''){
			groupsHtml += groupsHtmlOption;
			groupsHtml += '\t\t</select>\n';
			
			// $('div.'+position+' 	table.newBox tr:eq('+(startTrRow+1 + parseInt(comboCnt/4))+') > td:eq('+(comboCnt%4 * selectTdCol + 1)+')').append(groupsHtml);
			$('div.'+position+' 	table.newBox tr:eq('+(startTrRow + parseInt(comboCnt/4))+') > td:eq('+ (selectTdCol - 1) +')').append(groupsHtml);
		}
	}

	fnReSelect2();
}

//***********************************************************************************************************************
//콤보리스트 조회
$.fn.initSelect2 = function(url, param, select_all, options, callback) {
	var $this = this;
	$.ajax({
		dataType : 'json',
		type : 'post',
		mothod : 'post',
		url : url,
		data : param,
		crossDomain : true,
		success : function(data){
			var html = "";
			// if (data.returnRst == "success") {
				if (data.data.length > 0) {
					if (options != undefined && options != null && options != "") {
						for (var i = 0; i < data.data.length; i++) {
							var option_list = "";
							for (var key in options)
								if (key != "name")
									option_list += " " + key + "=\"" +  data.data[i][options[key]] + "\"";
							html += "<option" + option_list + ">" + data.data[i][options.name] + "</option>";
						}
					} else {
						for (var i = 0; i < data.data.length; i++) {
							html += "<option value=\"" + data.data[i].code + "\">" + data.data[i].code_nm + "</option>";
						}
					}
				}
				createOption($this, html, select_all);
				if (typeof(callback) == 'function') {
					callback();
				}
			// } else {
			// 	createOption($this, "");
			// }
		},
		error : function(){
			createOption($this, "");
		}
	});
	
	function createOption(that, option, select_all) {
		if (select_all == undefined || select_all == null) select_all = "";
		if (option == undefined || option == null) option = "";
		
		var str_all = "";
		if(select_all == "Y" || ('${sessionScope.admin_yn}' == "9999999") ){
			select_all = "";
		}
		
		$(that).children("option").remove();
		$(that)
			.append((select_all.toUpperCase() == "Y" || select_all + "" == "1") ? "<option value=\"\">전체</option>" : "")
			.append(str_all)
			.append(option)
			.select2({allowClear: false})
			.change();
	}
}
</script>
</body>
</html>