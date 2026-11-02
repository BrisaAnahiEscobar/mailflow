package com.mailflow.controller;

import com.mailflow.dto.HistorialCorreoDTO;
import com.mailflow.service.HistorialCorreoService;
import jakarta.validation.Valid;
import java.util.List;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/historial")
@RequiredArgsConstructor
public class HistorialCorreoController {

	private final HistorialCorreoService historialCorreoService;

	@GetMapping
	public ResponseEntity<List<HistorialCorreoDTO>> obtener(
			@AuthenticationPrincipal Long usuarioId) {
		return ResponseEntity.ok(historialCorreoService.obtenerHistorial(usuarioId));
	}

	@PostMapping
	public ResponseEntity<HistorialCorreoDTO> registrar(
			@AuthenticationPrincipal Long usuarioId,
			@Valid @RequestBody HistorialCorreoDTO dto) {
		return ResponseEntity.status(HttpStatus.CREATED)
				.body(historialCorreoService.registrarEscucha(usuarioId, dto));
	}
}