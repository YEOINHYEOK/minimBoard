-- 테이블 데이터 miniboard.categories:~3 rows (대략적) 내보내기
DELETE FROM `categories`;
INSERT INTO `categories` (`id`, `name`) VALUES
	(1, '웹'),
	(2, '코어'),
	(3, 'DB');

-- 테이블 데이터 miniboard.comments:~2 rows (대략적) 내보내기
DELETE FROM `comments`;
INSERT INTO `comments` (`id`, `user_id`, `post_id`, `content`, `created_at`) VALUES
	(2, 1, 2, '댓글 내용입니다', '2026-03-25 11:05:58'),
	(4, 1, 4, 'test', '2026-03-25 13:10:51');

-- 테이블 데이터 miniboard.posts:~11 rows (대략적) 내보내기
DELETE FROM `posts`;
INSERT INTO `posts` (`id`, `category_id`, `user_id`, `title`, `content`, `view_count`, `created_at`, `updated_at`) VALUES
	(2, 1, 1, '댓글', 'test내용입니다', 17, '2026-03-25 11:00:23', '2026-03-26 10:00:48'),
	(3, 1, 1, '232131', '434334', 3, '2026-03-25 12:46:45', '2026-03-25 14:29:44'),
	(4, 1, 1, 'test1', '1234', 21, '2026-03-25 13:09:37', '2026-03-26 13:18:01'),
	(5, 1, 1, 'web', '12344234234', 0, '2026-03-26 10:05:07', '2026-03-26 10:05:07'),
	(6, 1, 1, '테스트', '게시판 화면 내용입니다.', 4, '2026-03-26 10:05:43', '2026-03-26 10:40:54'),
	(7, 1, 1, '1', 'test', 12, '2026-03-26 10:56:59', '2026-03-26 11:27:37'),
	(9, 2, 1, 'test', '123', 2, '2026-03-26 11:28:48', '2026-03-26 12:29:56'),
	(10, 1, 1, 'Test', '1\n', 0, '2026-03-26 13:59:30', '2026-03-26 13:59:30'),
	(11, 1, 1, '페이징 테스트 용입니다. ', '페이징 테스트를 하기위한 테스트 게시글입니다.', 0, '2026-03-26 14:00:30', '2026-03-26 14:00:30'),
	(12, 1, 1, '제목 테스트입니다. ', 'test', 0, '2026-03-26 14:00:51', '2026-03-26 14:00:51'),
	(13, 1, 1, '3423435', 'qweeqe13eqr3214qewr23', 0, '2026-03-26 14:01:03', '2026-03-26 14:01:03');

-- 테이블 데이터 miniboard.users:~2 rows (대략적) 내보내기
DELETE FROM `users`;
INSERT INTO `users` (`id`, `username`, `password`, `email`, `created_at`, `updated_at`) VALUES
	(1, 'test', 'qwe123qwe', 'qwe123.gmail1', '2026-03-25 10:30:58', '2026-03-25 10:30:58'),
	(2, 'admin', 'weqe2312', 'test.email', '2026-03-26 15:12:02', '2026-03-26 15:12:15');

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
