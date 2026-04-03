package com.example.board.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.example.board.dto.PostPagedResponseDto;
import com.example.board.dto.PostResponseDto;
import com.example.board.dto.PostSearchRequest;
import com.example.board.dto.StatsDto;
import com.example.board.dto.UserPagedResponseDto;
import com.example.board.dto.UsersDto;
import com.example.board.mapper.PostMapper;
import com.example.board.mapper.UserMapper;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class UserService {

	private final UserMapper userMapper;

	public UserPagedResponseDto getAllUsers(int page, int size, String keyword, String sortColumn, String sortOrder) {
		int offset = (page - 1) * size;

		PostSearchRequest searchRequest = new PostSearchRequest();
		searchRequest.setPage(page);
		searchRequest.setSize(size);
		searchRequest.setKeyword(keyword);
		searchRequest.setSortColumn(sortColumn);
		searchRequest.setSortOrder(sortOrder);

		List<UsersDto> users = userMapper.getAllUsers(searchRequest);
		int totalCount = userMapper.getTotalCount(searchRequest);
		int totalPages = (int) Math.ceil((double) totalCount / size);

		return new UserPagedResponseDto(users, totalCount, totalPages, page);
	}

	public void patchUser(Long id, UsersDto users) {
		userMapper.updateUser(id, users);
	}

	public StatsDto getStats() {
		return userMapper.getStats();
	}

}
