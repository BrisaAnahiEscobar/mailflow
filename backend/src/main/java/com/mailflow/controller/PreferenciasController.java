package com.mailflow.controller;



import com.mailflow.dto.PreferenciasDTO;
import com.mailflow.service.PreferenciasService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/v1/preferencias")
@RequiredArgsConstructor
public class PreferenciasController {

	private final PreferenciasService preferenciasService;

	@GetMapping("/{usuarioId}")
	public ResponseEntity<PreferenciasDTO> obtener(
			@PathVariable Long usuarioId) {

		return ResponseEntity.ok(preferenciasService.obtener(usuarioId));
	}

	@PutMapping("/{usuarioId}")
	public ResponseEntity<PreferenciasDTO> actualizar(
			@PathVariable Long usuarioId,
			@RequestBody PreferenciasDTO dto) {

		return ResponseEntity.ok(preferenciasService.actualizar(usuarioId, dto));
	}
}