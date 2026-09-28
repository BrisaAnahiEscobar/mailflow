package com.mailflow.service;

import com.mailflow.dto.PreferenciasDTO;
import com.mailflow.model.Preferencias;
import com.mailflow.repository.PreferenciasRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class PreferenciasService {

	private final PreferenciasRepository preferenciasRepository;

	public PreferenciasDTO obtener(Long usuarioId) {
		Preferencias p = preferenciasRepository.findByUsuarioId(usuarioId)
				.orElseThrow(() -> new RuntimeException("Preferencias no encontradas"));

		PreferenciasDTO dto = new PreferenciasDTO();
		dto.setIdiomaTts(p.getIdiomaTts());
		dto.setVelocidadTts(p.getVelocidadTts());
		dto.setPitchTts(p.getPitchTts());
		return dto;
	}

	public PreferenciasDTO actualizar(Long usuarioId, PreferenciasDTO dto) {
		Preferencias p = preferenciasRepository.findByUsuarioId(usuarioId)
				.orElseThrow(() -> new RuntimeException("Preferencias no encontradas"));

		p.setIdiomaTts(dto.getIdiomaTts());
		p.setVelocidadTts(dto.getVelocidadTts());
		p.setPitchTts(dto.getPitchTts());

		preferenciasRepository.save(p);
		return dto;
	}
}
