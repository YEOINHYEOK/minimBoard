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

<!-- 버튼 -->
<button id="editBtn">수정</button>
<button id="deleteBtn">삭제</button>
<button onclick="location.href='/miniboard'">목록</button>

<hr/>

<!-- 댓글 목록 -->
<h3>댓글</h3>
<div id="commentList"></div>

<!-- 댓글 작성 -->
<div>
    <input  type="number" id="commentUserId"  placeholder="userId (테스트용)" style="width:120px"/>
    <textarea id="commentContent" placeholder="댓글을 입력하세요" rows="2" cols="50"></textarea>
    <button id="commentSubmit">댓글 작성</button>
</div>

<script>
    // URL에서 게시글 id 추출
    const postId = location.pathname.split("/").pop();

    // 게시글 상세 조회
    function loadPost() {
        $.ajax({
            url: "/api/posts/" + postId,
            method: "GET",
            success: function (res) {
                const post = res.data;
                $("#postTitle").text(post.title);
                $("#postCategory").text(post.categoryName);
                $("#postAuthor").text(post.username);
                $("#postViewCount").text(post.viewCount);
                $("#postCreatedAt").text(post.createdAt);
                $("#postContent").text(post.content);

                // 댓글 렌더링
                renderComments(post.comments);
            },
            error: function () {
                alert("게시글을 불러오는데 실패했습니다.");
            }
        });
    }

    // 댓글 렌더링
    function renderComments(comments) {
        const $list = $("#commentList").empty();

        if (!comments || comments.length === 0) {
            $list.append("<p>댓글이 없습니다.</p>");
            return;
        }

        comments.forEach(function (c) {
            $list.append(
                '<div style="border-bottom:1px solid #ccc; padding:8px">' +
                '<strong>' + c.commentname + '</strong> ' +
                '<span>' + c.createdAt + '</span>' +
                '<p>' + c.content + '</p>' +
                '<button class="deleteComment" data-id="' + c.id + '">삭제</button>' +
                '</div>'
            );
        });
    }

    // 댓글 삭제
    $(document).on("click", ".deleteComment", function () {
        const commentId = $(this).data("id");
        if (!confirm("댓글을 삭제하시겠습니까?")) return;

        $.ajax({
            url: "/api/posts/comments/" + commentId,
            method: "DELETE",
            success: function () {
                alert("댓글이 삭제되었습니다.");
                loadPost();
            },
            error: function () {
            	alert("댓글 삭제에 실패하였습니다.");
        	}
        });
    });

    // 댓글 작성
    $("#commentSubmit").on("click", function () {
        const userId  = $("#commentUserId").val();
        const content = $("#commentContent").val();

        if (!userId || !content) {
            alert("userId와 댓글 내용을 입력하세요.");
            return;
        }

        $.ajax({
            url: "/api/posts/" + postId + "/comments",
            method: "POST",
            contentType: "application/json",
            data: JSON.stringify({ userId: userId, content: content }),
            success: function () {
                $("#commentContent").val("");
                loadPost();
            },
        	error: function () {
            	alert("저장에 실패했습니다.");
        	}
        });
    });

    // 게시글 삭제
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
            },
            error: function () {
            	alert("삭제에 실패했습니다.");
        	}
        });
    });

    // 수정 버튼
    $("#editBtn").on("click", function () {
        location.href = "/miniboard/write?id=" + postId;
    });

    // 초기 로드
    loadPost();
</script>

</body>
</html>