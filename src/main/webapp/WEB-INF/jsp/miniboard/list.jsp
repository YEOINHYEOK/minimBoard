<%@ page contentType="text/html;charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<title>게시판</title>

<link rel="stylesheet"
	href="https://code.jquery.com/ui/1.13.2/themes/base/jquery-ui.css" />
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/free-jqgrid/4.15.5/css/ui.jqgrid.min.css" />
<link rel="stylesheet" href="/css/list.css" />
<link rel="icon" href="data:;base64,iVBORw0KGgo=">

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://code.jquery.com/ui/1.13.2/jquery-ui.min.js"></script>
<script
	src="https://cdn.jsdelivr.net/npm/free-jqgrid@4.15.5/js/i18n/grid.locale-kr.min.js"></script>
<script
	src="https://cdn.jsdelivr.net/npm/free-jqgrid@4.15.5/js/jquery.jqgrid.min.js"></script>

</head>
<body>

	<div class="header-right">
		<span id="userInfo"></span>
		<button id="userBtn">회원정보</button>
		<button id="logoutBtn">로그아웃</button>
	</div>

	<h2>게시판</h2>

	<div>
		<input type="text" id="searchTitle" placeholder="제목 검색" />
		<button id="searchBtn">검색</button>
		<button id="writeBtn">글쓰기</button>
	</div>

	<br />

	<table id="postGrid"></table>
	<div id="postPager"></div>

	<script>
		$(function() {
			const role = sessionStorage.getItem("role");
			const accessToken = sessionStorage.getItem("accessToken");

			if (role === "ADMIN") {
				userBtn.style.visibility = 'visible';
			}
			// 1. [인증 체크 제거 및 UI 조정]
			if (accessToken) {
				$(".auth-only").show();
				$("#loginBtn").hide();
			} else {
				$(".auth-only").hide();
				$("#loginBtn").show();
			}

			// 2. [AJAX 전역 설정]
			$.ajaxSetup({
				beforeSend : function(xhr) {
					if (accessToken) {
						xhr.setRequestHeader("Authorization", "Bearer "
								+ accessToken);
					}
				},
				error : function(xhr) {
					if (xhr.status === 401 && accessToken) {
						alert("인증이 만료되었습니다. 다시 로그인해주세요.");
						sessionStorage.clear();
						location.href = "/miniboard/login";
					}
				}
			});

			// jqGrid 초기화 (박스 크기 및 정렬 수정)
			$("#postGrid")
					.jqGrid(
							{
								url : "/api/posts",
								datatype : "json",
								mtype : "GET",

								jsonReader : {
									root : "data.list",
									total : "data.totalPages",
									records : "data.totalCount",
									page : "data.currentPage",
									repeatitems : false,
									id : "id"
								},

								prmNames : {
									page : "page",
									rows : "size",
									sort : "sortColumn",
									order : "sortOrder"
								},

								colModel : [
										{
											name : "id",
											label : "번호",
											width : 60,
											align : "center"
										},
										{
											name : "title",
											label : "제목",
											width : 350,
											formatter : function(val, opt, row) {
												return '<a href="/miniboard/' + row.id + '">'
														+ $('<div>').text(val)
																.html()
														+ '</a>';
											}
										}, {
											name : "categoryName",
											label : "카테고리",
											width : 100,
											align : "center"
										}, {
											name : "username",
											label : "작성자",
											width : 100,
											align : "center"
										}, {
											name : "viewCount",
											label : "조회수",
											width : 80,
											align : "center"
										}, {
											name : "createdAt",
											label : "작성일",
											width : 150,
											align : "center"
										}, {
											name : "updatedAt",
											label : "수정일",
											width : 150,
											align : "center"
										} ],

								rowNum : 10,
								rowList : [ 10, 20, 50 ],
								pager : "#postPager",
								viewrecords : true,
								caption : "게시글 목록",
								height : "auto",
								width : 1200, // 전체 너비를 900px로 고정하여 박스 형태 유지
								shrinkToFit : true, // 설정한 너비 내에서 컬럼 비율 조정
								sortname : "createdAt",
								sortorder : "desc",

								postData : {
									keyword : function() {
										return $("#searchTitle").val();
									}
								},

								loadError : function(xhr, status, error) {
									if (xhr.status !== 401) {
										alert("데이터를 불러오는 중 오류가 발생했습니다.");
									}
								}
							});

			// 검색 버튼
			$("#searchBtn").on("click", function() {
				$("#postGrid").jqGrid("setGridParam", {
					postData : {
						keyword : $("#searchTitle").val()
					},
					page : 1
				}).trigger("reloadGrid");
			});

			// 엔터키 검색
			$("#searchTitle").on("keypress", function(e) {
				if (e.key === "Enter")
					$("#searchBtn").trigger("click");
			});

			$("#writeBtn").on("click", function() {
				location.href = "/miniboard/write";
			});

			// 3. [로그아웃 기능]
			$("#logoutBtn")
					.on(
							"click",
							function() {
								const accessToken = sessionStorage
										.getItem("accessToken");

								$
										.ajax({
											url : "/api/auth/logout",
											method : "POST",
											headers : {
												"Authorization" : "Bearer "
														+ accessToken
											},
											complete : function() {
												sessionStorage
														.removeItem("accessToken");
												sessionStorage
														.removeItem("refreshToken");
												document.cookie = "accessToken=; path=/; expires=Thu, 01 Jan 1970 00:00:00 GMT";
												location.href = "/miniboard/login";
											}
										});
							});

			$("#userBtn").on("click", function() {
				location.href = "/miniboard/user";
			});
		});
	</script>

</body>
</html>