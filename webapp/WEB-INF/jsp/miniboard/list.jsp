<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>게시글 목록</title>

    <link rel="stylesheet" href="https://code.jquery.com/ui/1.13.2/themes/base/jquery-ui.css"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/free-jqgrid/4.15.5/css/ui.jqgrid.min.css"/>
    
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<script src="https://code.jquery.com/ui/1.13.2/jquery-ui.min.js"></script>
	<script src="https://cdn.jsdelivr.net/npm/free-jqgrid@4.15.5/js/i18n/grid.locale-kr.min.js"></script>
	<script src="https://cdn.jsdelivr.net/npm/free-jqgrid@4.15.5/js/jquery.jqgrid.min.js"></script>

</head>
<body>

<h2>게시글 목록</h2>

<!-- 검색 폼 -->
<div>
    <input type="text" id="searchTitle" placeholder="제목 검색"/>
    <button id="searchBtn">검색</button>
    <button id="writeBtn">글쓰기</button>
</div>

<br/>

<!-- JqGrid 테이블 -->
<table id="postGrid"></table>
<div id="postPager"></div>

<script>
$(function () {

    $("#postGrid").jqGrid({
        url: "/api/posts",
        datatype: "json",
        mtype: "GET",

        jsonReader: {
            root:        "data.list",
            total:       "data.totalPages",
            records:     "data.totalCount",
            page:        "data.currentPage",
            repeatitems: false,
            id:          "id"
        },

        prmNames: {
            page:  "page",
            rows:  "size",
            sort:  "sortColumn", 
            order: "sortOrder" 
        },

        colModel: [
            { name: "id",           label: "번호",    width: 60 },
            { name: "title",        label: "제목",    width: 300,
              formatter: function (val, opt, row) {
                  return '<a href="/miniboard/' + row.id + '">'
                       + $('<div>').text(val).html()
                       + '</a>';
              }
            },
            { name: "categoryName", label: "카테고리", width: 100 },
            { name: "username",     label: "작성자",  width: 100 },
            { name: "viewCount",    label: "조회수",  width: 80  },
            { name: "createdAt",    label: "작성일",  width: 150 }
        ],

        rowNum:       10,
        rowList:      [10, 20, 50],
        pager:        "#postPager",
        viewrecords:  true,
        caption:      "게시글 목록",
        height:       "auto",
        width:        "auto",
        sortname:     "createdAt",   // 기본 정렬 컬럼
        sortorder:    "desc",        // 기본 정렬 방향

        postData: {
            keyword: function () { return $("#searchTitle").val(); }
        },

        loadError: function (xhr, status, error) {
            alert("데이터를 불러오는 중 오류가 발생했습니다: " + error);
        }
    });

    // 검색 버튼
    $("#searchBtn").on("click", function () {
        $("#postGrid").jqGrid("setGridParam", {
            postData: { keyword: $("#searchTitle").val() },
            page: 1
        }).trigger("reloadGrid");
    });

    // 엔터키 검색
    $("#searchTitle").on("keypress", function (e) {
        if (e.key === "Enter") $("#searchBtn").trigger("click");
    });

    $("#writeBtn").on("click", function () {
        location.href = "/miniboard/write";
    });

});
</script>

</body>
</html>