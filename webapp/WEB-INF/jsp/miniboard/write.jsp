<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>게시글 작성</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>

<h2 id="pageTitle">게시글 작성</h2>

<div>
    <input  type="number" id="userId"     placeholder="userId (테스트용)"/><br/><br/>
    <select id="categoryId">
        <option value="">카테고리 선택</option>
    </select><br/><br/>
    <input  type="text"   id="title"      placeholder="제목" style="width:400px"/><br/><br/>
    <textarea id="content" placeholder="내용" rows="10" cols="60"></textarea><br/><br/>
    <button id="submitBtn">저장</button>
    <button onclick="location.href='/miniboard'">취소</button>
</div>

<script>
    const urlParams = new URLSearchParams(location.search);
    const postId    = urlParams.get("id");
    const isEdit    = Boolean(postId);

    $(document).ready(function () {
        // 1. 카테고리 목록을 먼저 불러옵니다.
        $.when(loadCategories()).then(function () {
            // 2. 카테고리 로딩이 완료된 후, 수정 모드라면 기존 데이터를 로드합니다.
            if (isEdit) {
                initEditMode();
            }
        });
    });

    // 카테고리 목록 API 호출 함수
    function loadCategories() {
        return $.ajax({
            url: "/api/categories",
            method: "GET",
            success: function (res) {
                console.log("서버 응답 데이터:", res);
                const categories = res.data;

                if (!categories || categories.length === 0) {
                    console.warn("카테고리 데이터가 비어있습니다.");
                    return;
                }

                categories.forEach(category => {
                    console.log("개별 카테고리 객체:", category);
                    $('#categoryId').append('<option value="' + category.id + '">' + category.name + '</option>');
                });
            },
            error: function (xhr) {
                console.error("연결 실패 상태 코드:", xhr.status);
            }
        });
    }

    // 수정 모드 초기 설정 및 데이터 로드
    function initEditMode() {
        $("#pageTitle").text("게시글 수정");
        $("#submitBtn").text("수정");

        $.ajax({
            url: "/api/posts/" + postId,
            method: "GET",
            success: function (res) {
                const post = res.data;
                $("#userId").val(post.userId).prop("readonly", true);
                $("#categoryId").val(post.categoryId);
                $("#title").val(post.title);
                $("#content").val(post.content);
            },
            error: function (xhr) {
                console.error("게시글 로딩 실패:", xhr.status);
            }
        });
    }

    // 저장/수정 버튼 클릭 이벤트
    $("#submitBtn").on("click", function () {
        const data = {
            userId:     parseInt($("#userId").val()),
            categoryId: parseInt($("#categoryId").val()),
            title:      $("#title").val(),
            content:    $("#content").val()
        };

        if (!data.userId || !data.categoryId || !data.title || !data.content) {
            alert("모든 필수 항목을 입력하거나 선택하세요.");
            return;
        }

        $.ajax({
            url:         isEdit ? "/api/posts/" + postId : "/api/posts",
            method:      isEdit ? "PUT" : "POST",
            contentType: "application/json",
            data:        JSON.stringify(data),
            success: function (res) {
                alert(res.message);
                location.href = "/miniboard";
            },
            error: function () {
                alert("저장에 실패했습니다.");
            }
        });
    });
</script>

</body>
</html>