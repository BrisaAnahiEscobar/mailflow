package com.mailflow.controller;

import com.mailflow.dto.AuthRequestDTO;
import com.mailflow.service.UsuarioService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/v1/auth")
@RequiredArgsConstructor
public class AuthController {

	private final UsuarioService usuarioService;

	@PostMapping("/google")
	public ResponseEntity<AuthRequestDTO> autenticarConGoogle(
			@RequestBody AuthRequestDTO request) {

		// Por ahora recibe googleSub y email directamente migra en Fase 4
		AuthRequestDTO response = usuarioService.registrarOLoguear(
				request.getToken(),
				request.getToken() + "@mailflow.dev"
		);

		return ResponseEntity.ok(response);
	}
}