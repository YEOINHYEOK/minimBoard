<%@ page contentType="text/html;charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<title>회원 목록</title>

<link rel="stylesheet"
	href="https://code.jquery.com/ui/1.13.2/themes/base/jquery-ui.css" />
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/free-jqgrid/4.15.5/css/ui.jqgrid.min.css" />
<link rel="stylesheet" href="/css/user.css" />
<link rel="icon" href="data:;base64,iVBORw0KGgo=">

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://code.jquery.com/ui/1.13.2/jquery-ui.min.js"></script>
<script
	src="https://cdn.jsdelivr.net/npm/free-jqgrid@4.15.5/js/i18n/grid.locale-kr.min.js"></script>
<script
	src="https://cdn.jsdelivr.net/npm/free-jqgrid@4.15.5/js/jquery.jqgrid.min.js"></script>
</head>
<body>
	<h2>회원 목록</h2>

	<div class="header-right">
		<span id="userInfo"></span>
		<button id="boardBtn">게시판</button>
		<button id="logoutBtn">로그아웃</button>
	</div>

	<div style="display: flex; align-items: center; gap: 20px;">
		<div>
			<input type="text" id="searchTitle" placeholder="아이디 검색" />
			<button id="searchBtn">검색</button>
		</div>

		<table border="1" style="border-collapse: collapse;">
			<thead>
				<tr>
					<th style="padding: 5px 10px;">게시글 수</th>
					<th style="padding: 5px 10px;">회원 수</th>
					<th style="padding: 5px 10px;">댓글 수</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td id="count_posts" align="center">0</td>
					<td id="count_users" align="center">0</td>
					<td id="count_comments" align="center">0</td>
				</tr>
			</tbody>
		</table>
	</div>

	<br />

	<table id="postGrid"></table>
	<div id="userPager"></div>

	<!-- 모달 -->
	<div id="modalBackdrop"></div>
	<div id="userModal">
		<h4 style="margin-top: 0;">권한 수정</h4>
		<hr>
		<div class="modal">
			<label>사용자 ID : </label> <input type="text" id="modalUserId" readonly
				style="background: #eee; border: 1px solid #ccc; width: 150px;">
		</div>
		<div class="modal">
			<label>권한 선택 : </label> <select id="modalRoleSelect"
				style="width: 150px; padding: 3px;">
				<option value="USER">일반 사용자</option>
				<option value="ADMIN">관리자</option>
			</select>
		</div>
		<hr>
		<div class="modal-buttons">
			<button id="saveBtn">저장</button>
			<button id="closeBtn">취소</button>
		</div>
	</div>
	<script>
		$(function() {
			// 1. 초기 정보 확인
			let accessToken = sessionStorage.getItem("accessToken");
			const role = sessionStorage.getItem("role");

			if (!accessToken) {
				alert("로그인이 필요합니다.");
				location.href = "/miniboard/login";
				return;
			} else if (role !== "ADMIN") {
				alert("관리자 권한이 필요합니다.");
				location.href = "/miniboard";
				return;
			}

			// 2. [중요] 통합 AJAX 전역 설정 (재발급 로직 포함)
			// 이 설정 하나만 남기고 다른 $.ajaxSetup은 모두 삭제해야 합니다.
			$
					.ajaxSetup({
						beforeSend : function(xhr) {
							const currentToken = sessionStorage
									.getItem("accessToken");
							if (currentToken) {
								xhr.setRequestHeader("Authorization", "Bearer "
										+ currentToken);
							}
						},
						error : function(xhr, status, error) {
							const originalRequest = this; // 실패한 요청 정보를 변수에 저장

							// 401 Unauthorized 발생 시 (토큰 만료)
							if (xhr.status === 401 || xhr.status === 403) {
								const refreshToken = sessionStorage
										.getItem("refreshToken");

								if (refreshToken) {
									$
											.ajax({
												url : "/api/auth/refresh",
												method : "POST",
												contentType : "application/json",
												data : JSON.stringify({
													refreshToken : refreshToken
												}),
												success : function(response) {
													// 재발급 성공 시: response 구조에 따라 수정 필요 (예: response.accessToken)
													const newAccessToken = response.accessToken
															|| (response.data && response.data.accessToken);
													const newRefreshToken = response.refreshToken
															|| (response.data && response.data.refreshToken);

													if (newAccessToken) {
														sessionStorage.setItem(
																"accessToken",
																newAccessToken);
														if (newRefreshToken)
															sessionStorage
																	.setItem(
																			"refreshToken",
																			newRefreshToken);

														// 원래 실패했던 요청에 새 토큰을 끼워서 재시도
														originalRequest.headers["Authorization"] = "Bearer "
																+ newAccessToken;
														$.ajax(originalRequest);
													}
												},
												error : function() {
													alert("세션이 완전히 만료되었습니다. 다시 로그인해주세요.");
													sessionStorage.clear();
													location.href = "/miniboard/login";
												}
											});
								} else {
									location.href = "/miniboard/login";
								}
							}
						}
					});

			// 3. jqGrid 초기화
			$("#postGrid")
					.jqGrid(
							{
								url : "/api/admin/users",
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
											name : "username",
											label : "회원",
											width : 80,
											align : "center"
										},
										{
											name : "email",
											label : "이메일",
											width : 150,
											align : "center"
										},
										{
											name : "role",
											label : "권한",
											width : 80,
											align : "center",
											formatter : function(val, opt, row) {
												return '<a href="javascript:void(0);" onclick="openDetailModal('
														+ row.id
														+ ', \''
														+ val
														+ '\')">'
														+ val
														+ '</a>';
											}
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
								pager : "#userPager",
								viewrecords : true,
								caption : "회원 목록",
								height : "auto",
								shrinkToFit : true,
								sortname : "createdAt",
								sortorder : "desc",
								postData : {
									keyword : function() {
										return $("#searchTitle").val();
									}
								},
								loadError : function(xhr) {
									if (xhr.status !== 401
											&& xhr.status !== 403) {
										alert("데이터 로드 중 오류가 발생했습니다.");
									}
								}
							});

			// 4. 이벤트 핸들러들
			$("#searchBtn").on("click", function() {
				$("#postGrid").jqGrid("setGridParam", {
					postData : {
						keyword : $("#searchTitle").val()
					},
					page : 1
				}).trigger("reloadGrid");
			});

			$("#searchTitle").on("keypress", function(e) {
				if (e.key === "Enter")
					$("#searchBtn").trigger("click");
			});

			$("#saveBtn").on("click", function() {
				const userId = $("#modalUserId").val();
				const newRole = $("#modalRoleSelect").val();
				if (!confirm("권한을 수정하시겠습니까?"))
					return;

				$.ajax({
					url : "/api/admin/users/" + userId + "/role",
					method : "PATCH",
					contentType : "application/json",
					data : JSON.stringify({
						role : newRole
					}),
					success : function() {
						alert("수정되었습니다!");
						closeModal();
						$("#postGrid").trigger("reloadGrid");
					}
				});
			});

			$("#closeBtn, #modalBackdrop").on("click", closeModal);
			$("#boardBtn").on("click", function() {
				location.href = "/miniboard";
			});

			// 초기 통계 데이터 로드
			loadStats();

			// 로그아웃 버튼
			$("#logoutBtn")
					.on(
							"click",
							function() {
								const token = sessionStorage
										.getItem("accessToken");
								$
										.ajax({
											url : "/api/auth/logout",
											method : "POST",
											headers : {
												"Authorization" : "Bearer "
														+ token
											},
											complete : function() {
												sessionStorage.clear();
												document.cookie = "accessToken=; path=/; expires=Thu, 01 Jan 1970 00:00:00 GMT";
												location.href = "/miniboard/login";
											}
										});
							});
		});

		// 전역 함수들
		function openDetailModal(id, currentRole) {
			$("#modalUserId").val(id);
			$("#modalRoleSelect").val(currentRole);
			$("#userModal, #modalBackdrop").show();
		}

		function closeModal() {
			$("#userModal, #modalBackdrop").hide();
		}

		function loadStats() {
			$.ajax({
				url : "/api/admin/stats",
				method : "GET",
				success : function(response) {
					if (response && response.success && response.data) {
						const stats = response.data;
						$("#count_posts").text(stats.totalPosts);
						$("#count_users").text(stats.totalUsers);
						$("#count_comments").text(stats.totalComments);
					}
				}
			});
		}
	</script>

</body>
</html>
