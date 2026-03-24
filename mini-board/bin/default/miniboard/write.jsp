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
    <input  type="number" id="userId"     placeholder="userId"/><br/><br/>
    <input  type="number" id="categoryId" placeholder="categoryId"/><br/><br/>
    <input  type="text"   id="title"      placeholder="제목" style="width:400px"/><br/><br/>
    <textarea id="content" placeholder="내용" rows="10" cols="60"></textarea><br/><br/>
    <button id="submitBtn">저장</button>
    <button onclick="location.href='/posts'">취소</button>
</div>

<script>
    const urlParams = new URLSearchParams(location.search);
    const postId    = urlParams.get("id");
    const isEdit    = !!postId;

    if (isEdit) {
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
            userId:     parseInt($("#userId").val()),
            categoryId: parseInt($("#categoryId").val()),
            title:      $("#title").val(),
            content:    $("#content").val()
        };

        if (!data.userId || !data.title || !data.content) {
            alert("필수 항목을 입력하세요.");
            return;
        }

        $.ajax({
            url:         isEdit ? "/api/posts/" + postId : "/api/posts",
            method:      isEdit ? "PUT" : "POST",
            contentType: "application/json",
            data:        JSON.stringify(data),
            success: function (res) {
                alert(res.message);
                location.href = "/posts";
            },
            error: function () {
                alert("저장에 실패했습니다.");
            }
        });
    });
</script>

</body>
</html>