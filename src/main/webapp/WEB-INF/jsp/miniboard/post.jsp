<%@ page contentType="text/html;charset=UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<!DOCTYPE html>
<html>
<head>
<title>게시글 상세</title>
<link rel="stylesheet" href="/css/post.css" />
<link rel="icon" href="data:;base64,iVBORw0KGgo=">

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>

<div class="container">
    <div id="postDetail">
        <h2 id="postTitle">로딩 중...</h2>
        <div class="post-info">
            <div>카테고리: <span id="postCategory"></span></div>
            <div>작성자: <span id="postAuthor"></span></div>
            <div>조회수: <span id="postViewCount"></span></div>
            <div>작성일: <span id="postCreatedAt"></span></div>
        </div>
        <div id="postContent">내용을 불러오는 중입니다...</div>
    </div>

    <div style="text-align: right;">
        <button id="editBtn">수정</button>
        <button id="deleteBtn">삭제</button>
        <button class="btn-list" onclick="location.href='/miniboard'">목록</button>
    </div>

    <div class="comment-section">
        <h3>댓글 <small style="color:#999; font-weight:normal;">Comments</small></h3>
        <div id="commentList"></div>

        <div class="comment-form">
            <input type="hidden" id="commentUserId">
            <strong>작성자: <sec:authentication property='name' /></strong>
            <textarea id="commentContent" placeholder="댓글을 입력하세요" rows="3"></textarea>
            <button id="commentSubmit">댓글 등록</button>
        </div>
    </div>
</div>

<script>
    const role = sessionStorage.getItem("role");
    const postId = location.pathname.split("/").pop();

    function loadPost() {
        $.ajax({
            url : "/api/posts/" + postId,
            method : "GET",
            success : function(res) {
                const post = res.data;
                $("#postTitle").text(post.title);
                $("#postCategory").text(post.categoryName);
                $("#postAuthor").text(post.username);
                $("#postViewCount").text(post.viewCount);
                $("#postCreatedAt").text(post.createdAt);
                $("#postContent").text(post.content);
                renderComments(post.comments);
            },
            error : function() {
                alert("게시글을 불러오는데 실패했습니다.");
            }
        });
    }

    function renderComments(comments) {
        const loginUser = "<sec:authentication property='name'/>";
        const $list = $("#commentList").empty();
        $("#commentUserId").val(loginUser);

        if (!comments || comments.length === 0) {
            $list.append("<p style='color:#999; text-align:center; padding:20px;'>댓글이 없습니다.</p>");
            return;
        }

        comments.forEach(function(c) {
            $list.append(
                '<div class="comment-item">' +
                    '<div class="comment-header">' +
                        '<span class="comment-author">' + c.commentname + '</span>' +
                        '<span class="comment-date">' + c.createdAt + '</span>' +
                    '</div>' +
                    '<p class="comment-content">' + c.content + '</p>' +
                    '<button class="deleteComment" data-id="' + c.id + '">삭제</button>' +
                '</div>'
            );
        });
    }

    // [기존 이벤트 리스너 코드 동일]
    $(document).on("click", ".deleteComment", function() {
        const commentId = $(this).data("id");
        if (!confirm("댓글을 삭제하시겠습니까?")) return;
        
        const url = (role === "ADMIN") ? "/api/admin/comments/" + commentId : "/api/posts/comments/" + commentId;
        
        $.ajax({
            url : url,
            method : "DELETE",
            success : function() {
                alert("댓글이 삭제되었습니다.");
                loadPost();
            },
            error : function() {
                alert("댓글 삭제 권한이 없거나 실패하였습니다.");
            }
        });
    });

    $("#commentSubmit").on("click", function() {
        const content = $("#commentContent").val();
        if (!content.trim()) {
            alert("내용을 입력하세요.");
            return;
        }
        $.ajax({
            url : "/api/posts/" + postId + "/comments",
            method : "POST",
            contentType : "application/json",
            data : JSON.stringify({ content : content }),
            success : function() {
                $("#commentContent").val("");
                loadPost();
            },
            error : function() {
                alert("저장에 실패했습니다.");
            }
        });
    });

    $("#deleteBtn").on("click", function() {
        if (!confirm("정말로 삭제하시겠습니까?")) return;
        const url = (role === "ADMIN") ? "/api/admin/posts/" + postId : "/api/posts/" + postId;
        $.ajax({
            url : url,
            method : "DELETE",
            success : function() {
                alert("삭제되었습니다.");
                location.href = "/miniboard";
            },
            error : function() {
                alert("삭제 권한이 없거나 실패했습니다.");
            }
        });
    });

    $("#editBtn").on("click", function() {
        location.href = "/miniboard/write?id=" + postId;
    });

    loadPost();
</script>

</body>
</html>