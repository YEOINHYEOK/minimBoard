package com.example.board.security;

import lombok.RequiredArgsConstructor;
import org.springframework.security.core.userdetails.*;
import org.springframework.security.core.userdetails.User;
import org.springframework.stereotype.Service;

import com.example.board.dto.UsersDto;

@Service
@RequiredArgsConstructor
public class CustomUserDetailsService implements UserDetailsService {

	private final MemberMapper memberMapper;

	@Override
	public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
		UsersDto member = memberMapper.findByUsername(username)
				.orElseThrow(() -> new UsernameNotFoundException("존재하지 않는 유저: " + username));

		return User.builder().username(member.getUsername()).password(member.getPassword())
				.roles(member.getRole().name()).build();
	}
}