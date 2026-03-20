# mini-board

> Java Spring 실무 역량 강화 과제 | 1~2주차  
> 미니 게시판 REST API 서버 + JSP/JqGrid 화면 구현

---

## 📌 프로젝트 소개

Spring Boot 기반의 미니 게시판 서비스입니다.  
MyBatis를 활용한 게시글·댓글 CRUD REST API를 구현하고, JSP + JqGrid로 게시판 화면을 완성합니다.

**학습 목표**
- MySQL DDL 직접 설계 및 테이블 생성
- MyBatis Mapper XML을 통한 동적 쿼리 작성
- RESTful API 설계 원칙 적용 (DTO 분리, 예외 처리, 공통 응답 형식)
- LIMIT/OFFSET 기반 페이지네이션 직접 구현
- JqGrid와 Spring REST API 연동

---

## 🛠 기술 스택

| 분류 | 기술 |
|------|------|
| Language | Java 17 |
| Framework | Spring Boot 3.x |
| Build | Gradle |
| ORM | MyBatis |
| Database | MySQL 8.x |
| View | JSP, JqGrid, jQuery |
| 형상 관리 | 사내 GitLab |

---

## ⚙️ 실행 방법

### 사전 준비

- Java 17 이상 설치
- MySQL 8.x 설치 및 실행
- 사내 GitLab에서 프로젝트 clone