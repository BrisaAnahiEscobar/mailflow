package com.mailflow.service;

import com.mailflow.dto.PreferenciasDTO;
import com.mailflow.exception.RecursoNoEncontradoException;
import com.mailflow.model.Preferencias;
import com.mailflow.model.Usuario;
import com.mailflow.repository.PreferenciasRepository;
import com.mailflow.repository.UsuarioRepository;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class PreferenciasService {

	private final PreferenciasRepository preferenciasRepository;
	private final UsuarioRepository usuarioRepository;

	@Transactional
	public PreferenciasDTO obtener(Long usuarioId) {
		return toDTO(obtenerOCrear(usuarioId));
	}

	@Transactional
	public PreferenciasDTO actualizar(Long usuarioId, PreferenciasDTO dto) {
		Preferencias p = obtenerOCrear(usuarioId);
		p.setIdiomaTts(dto.getIdiomaTts());
		p.setVelocidadTts(dto.getVelocidadTts());
		p.setPitchTts(dto.getPitchTts());
		return toDTO(preferenciasRepository.save(p));
	}

	private Preferencias obtenerOCrear(Long usuarioId) {
		return preferenciasRepository.findByUsuarioId(usuarioId).orElseGet(() -> {
			Usuario u = usuarioRepository.findById(usuarioId)
					.orElseThrow(() -> new RecursoNoEncontradoException("Usuario no encontrado"));
			Preferencias nueva = new Preferencias();
			nueva.setUsuario(u);
			return preferenciasRepository.save(nueva);
		});
	}

	private PreferenciasDTO toDTO(Preferencias p) {
		PreferenciasDTO dto = new PreferenciasDTO();
		dto.setIdiomaTts(p.getIdiomaTts());
		dto.setVelocidadTts(p.getVelocidadTts());
		dto.setPitchTts(p.getPitchTts());
		return dto;
	}
}