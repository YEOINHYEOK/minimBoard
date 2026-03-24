<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>게시글 상세</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>

<div id="postDetail">
    <h2 id="postTitle"></h2>
    <p>카테고리: <span id="postCategory"></span></p>
    <p>작성자: <span id="postAuthor"></span></p>
    <p>조회수: <span id="postViewCount"></span></p>
    <p>작성일: <span id="postCreatedAt"></span></p>
    <hr/>
    <div id="postContent"></div>
</div>

<hr/>

<button id="editBtn">수정</button>
<button id="deleteBtn">삭제</button>
<button onclick="location.href='/posts'">목록</button>

<hr/>

<script>

    function loadPost() {
        $.ajax({
            url: "/api/posts/" + postId,
            method: "GET",
            success: function (res) {
                const post = res.data;
                $("#postTitle").text(post.title);
                $("#postCategory").text(post.categoryName);
                $("#postAuthor").text(post.authorName);
                $("#postViewCount").text(post.viewCount);
                $("#postCreatedAt").text(post.createdAt);
                $("#postContent").text(post.content);

            },
            error: function () {
                alert("게시글을 불러오는데 실패했습니다.");
            }
        });
    }

    $("#deleteBtn").on("click", function () {
        const userId = prompt("userId를 입력하세요 (테스트용)");
        if (!userId) return;

        $.ajax({
            url: "/api/posts/" + postId,
            method: "DELETE",
            contentType: "application/json",
            data: JSON.stringify({ userId: userId }),
            success: function () {
                alert("삭제되었습니다.");
                location.href = "/posts";
            }
        });
    });

    $("#editBtn").on("click", function () {
        location.href = "/posts/write?id=" + postId;
    });

    loadPost();
</script>

</body>
</html>