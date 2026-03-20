package com.example.board.mapper;

import com.example.board.dto.UserDto;
import org.apache.ibatis.annotations.Mapper;
import java.util.List;

@Mapper
public interface UserMapper {
	
    List<UserDto> selectAllUsers();
}