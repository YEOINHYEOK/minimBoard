<%@ page contentType="text/html;charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<title>게시글 작성</title>
<link rel="stylesheet" href="/css/write.css" />
<link rel="icon" href="data:;base64,iVBORw0KGgo=">

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>

	<div class="write-container">
		<h2 id="pageTitle">게시글 작성</h2>

		<div class="form-wrap">
			<input type="text" id="title" placeholder="제목을 입력하세요" /> <select
				id="categoryId">
				<option value="">카테고리 선택</option>
			</select>

			<textarea id="content" placeholder="내용을 입력하세요"></textarea>
		</div>

		<div class="btn-group">
			<button class="cancel-btn" onclick="location.href='/miniboard'">취소</button>
			<button id="submitBtn">저장</button>
		</div>
	</div>

	<script>
    const urlParams = new URLSearchParams(location.search);
    const postId    = urlParams.get("id");
    const isEdit    = Boolean(postId);
    
    // 2. [인증 체크 및 설정]
    const accessToken = sessionStorage.getItem("accessToken");
    
    if (!accessToken) {
        alert("로그인이 필요합니다.");
        location.href = "/miniboard/login";
    }

    // 모든 AJAX 요청에 토큰 자동 포함
    $.ajaxSetup({
        beforeSend: function (xhr) {
            xhr.setRequestHeader("Authorization", "Bearer " + accessToken);
        },
        error: function (xhr) {
            if (xhr.status === 401 || xhr.status === 403) {
                alert("인증이 만료되었거나 권한이 없습니다.");
                location.href = "/miniboard/login";
            }
        }
    });

    $(document).ready(function () {
        loadCategories().then(function () {
            if (isEdit) {
                initEditMode();
            }
        });
    });

    function loadCategories() {
        return $.ajax({
            url: "/api/categories",
            method: "GET",
            success: function (res) {
                const categories = res.data;
                categories.forEach(category => {
                    $('#categoryId').append('<option value="' + category.id + '">' + category.name + '</option>');
                });
            }
        });
    }

    function initEditMode() {
        $("#pageTitle").text("게시글 수정");
        $("#submitBtn").text("수정");

        $.ajax({
            url: "/api/posts/" + postId,
            method: "GET",
            success: function (res) {
                const post = res.data;
                $("#categoryId").val(post.categoryId);
                $("#title").val(post.title);
                $("#content").val(post.content);
            }
        });
    }

    $("#submitBtn").on("click", function () {
        const data = {
            categoryId: parseInt($("#categoryId").val()),
            title:      $("#title").val(),
            content:    $("#content").val()
        };

        if (!data.categoryId || !data.title || !data.content) {
            alert("모든 필수 항목을 입력하세요.");
            return;
        }

        $.ajax({
            url:		isEdit ? "/api/posts/" + postId : "/api/posts",
            method:		isEdit ? "PUT" : "POST",
            contentType: "application/json",
            data:        JSON.stringify(data),
            success: function (res) {
                alert(res.message);
                location.href = "/miniboard";
            },
            error: function () {
                alert("저장에 실패했습니다. 본인 글이 맞는지 확인해주세요.");
            }
        });
    });
</script>

</body>
</html>