<%@ page contentType="text/html;charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<title>로그인</title>
<link rel="stylesheet" href="/css/login.css" />
<link rel="icon" href="data:;base64,iVBORw0KGgo=">

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

</head>
<body>

	<div class="login-box">
		<h2>게시판 로그인</h2>
		<input type="text" id="username" placeholder="아이디" /> <input
			type="password" id="password" placeholder="비밀번호" />
		<button id="loginBtn">로그인</button>
		<button id="authBtn">비로그인</button>
	</div>

	<script>
		function Login() {
			const username = $("#username").val().trim();
			const password = $("#password").val().trim();

			if (!username || !password) {
				alert("아이디와 비밀번호를 입력해주세요.");
				return;
			}

			$.ajax({
				url : "/api/auth/login",
				method : "POST",
				contentType : "application/json",
				data : JSON.stringify({
					username : username,
					password : password
				}),
				success : function(res) {
					document.cookie = "accessToken=" + res.accessToken
							+ "; path=/; Max-Age=900";
					sessionStorage.setItem("accessToken", res.accessToken);
					$.ajax({
						url : "/api/auth/me",
						method : "GET",
						headers : {
							"Authorization" : "Bearer " + res.accessToken
						},
						success : function(me) {
							sessionStorage.setItem("role", me.role);
							location.href = "/miniboard";
						},
						error : function() {
							location.href = "/miniboard";
						}
					});
				},
				error : function(xhr) {
					alert("아이디 또는 비밀번호가 올바르지 않습니다.");
					$("#username").val("");
					$("#password").val("");
					$("#username").focus();
				}
			});
		}

		$("#loginBtn").on("click", function() {
			Login();
		});

		$("#username, #password").on("keypress", function(e) {
			if (e.key === "Enter") {
				Login();
			}
		});

		$("#authBtn").on("click", function() {
			location.href = "/miniboard";
		});
	</script>

</body>
</html>
