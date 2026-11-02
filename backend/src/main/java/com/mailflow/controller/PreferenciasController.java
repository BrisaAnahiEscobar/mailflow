package com.mailflow.controller;

import com.mailflow.dto.PreferenciasDTO;
import com.mailflow.service.PreferenciasService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/preferencias")
@RequiredArgsConstructor
public class PreferenciasController {

	private final PreferenciasService preferenciasService;

	@GetMapping
	public ResponseEntity<PreferenciasDTO> obtener(@AuthenticationPrincipal Long usuarioId) {
		return ResponseEntity.ok(preferenciasService.obtener(usuarioId));
	}

	@PutMapping
	public ResponseEntity<PreferenciasDTO> actualizar(
			@AuthenticationPrincipal Long usuarioId,
			@Valid @RequestBody PreferenciasDTO dto) {
		return ResponseEntity.ok(preferenciasService.actualizar(usuarioId, dto));
	}
}