package com.mailflow.dto;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class AuthResponseDTO {
	private String token;
	private String email;
	private Long usuarioId;
}
