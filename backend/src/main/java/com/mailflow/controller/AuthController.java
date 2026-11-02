package com.mailflow.controller;

import com.mailflow.dto.AuthResponseDTO;
import com.mailflow.dto.GoogleAuthRequestDTO;
import com.mailflow.service.UsuarioService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/v1/auth")
@RequiredArgsConstructor
public class AuthController {

	private final UsuarioService usuarioService;

	@PostMapping("/google")
	public ResponseEntity<AuthResponseDTO> autenticarConGoogle(
			@Valid @RequestBody GoogleAuthRequestDTO request) {
		return ResponseEntity.ok(usuarioService.autenticarConGoogle(request.getIdToken()));
	}
}

