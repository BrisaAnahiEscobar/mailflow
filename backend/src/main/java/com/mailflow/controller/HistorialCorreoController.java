package com.mailflow.controller;

import com.mailflow.dto.HistorialCorreoDTO;
import com.mailflow.service.HistorialCorreoService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/v1/historial")
@RequiredArgsConstructor
public class HistorialCorreoController {

	private final HistorialCorreoService historialCorreoService;

	@GetMapping("/{usuarioId}")
	public ResponseEntity<List<HistorialCorreoDTO>> obtener(
			@PathVariable Long usuarioId) {

		return ResponseEntity.ok(historialCorreoService.obtenerHistorial(usuarioId));
	}

	@PostMapping("/{usuarioId}")
	public ResponseEntity<HistorialCorreoDTO> registrar(
			@PathVariable Long usuarioId,
			@RequestBody HistorialCorreoDTO dto) {

		return ResponseEntity.ok(
				historialCorreoService.registrarEscucha(usuarioId, dto));
	}
}