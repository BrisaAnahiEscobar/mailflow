package com.mailflow.service;

import com.mailflow.dto.HistorialCorreoDTO;
import com.mailflow.exception.RecursoNoEncontradoException;
import com.mailflow.model.HistorialCorreo;
import com.mailflow.model.Usuario;
import com.mailflow.repository.HistorialCorreoRepository;
import com.mailflow.repository.UsuarioRepository;
import jakarta.transaction.Transactional;
import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class HistorialCorreoService {

	private final HistorialCorreoRepository historialCorreoRepository;
	private final UsuarioRepository usuarioRepository;

	public List<HistorialCorreoDTO> obtenerHistorial(Long usuarioId) {
		return historialCorreoRepository
				.findByUsuarioIdOrderByFechaEscuchaDesc(usuarioId)
				.stream()
				.map(this::toDTO)
				.collect(Collectors.toList());
	}

	@Transactional
	public HistorialCorreoDTO registrarEscucha(Long usuarioId, HistorialCorreoDTO dto) {
		Usuario usuario = usuarioRepository.findById(usuarioId)
				.orElseThrow(() -> new RecursoNoEncontradoException("Usuario no encontrado"));

		HistorialCorreo historial = new HistorialCorreo();
		historial.setUsuario(usuario);
		historial.setGmailMessageId(dto.getGmailMessageId());
		historial.setAsunto(truncar(dto.getAsunto(), 255));
		historial.setRemitente(truncar(dto.getRemitente(), 255));
		historial.setEscuchado(true);
		historial.setFechaEscucha(LocalDateTime.now());

		return toDTO(historialCorreoRepository.save(historial));
	}

	private String truncar(String s, int max) {
		return (s == null || s.length() <= max) ? s : s.substring(0, max);
	}

	private HistorialCorreoDTO toDTO(HistorialCorreo h) {
		HistorialCorreoDTO dto = new HistorialCorreoDTO();
		dto.setId(h.getId());
		dto.setGmailMessageId(h.getGmailMessageId());
		dto.setAsunto(h.getAsunto());
		dto.setRemitente(h.getRemitente());
		dto.setEscuchado(h.getEscuchado());
		dto.setFechaEscucha(h.getFechaEscucha());
		return dto;
	}
}