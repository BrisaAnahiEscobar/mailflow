package com.mailflow.service;

import com.mailflow.dto.HistorialCorreoDTO;
import com.mailflow.model.HistorialCorreo;
import com.mailflow.model.Usuario;
import com.mailflow.repository.HistorialCorreoRepository;
import com.mailflow.repository.UsuarioRepository;
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

	public HistorialCorreoDTO registrarEscucha(Long usuarioId, HistorialCorreoDTO dto) {
		Usuario usuario = usuarioRepository.findById(usuarioId)
				.orElseThrow(() -> new RuntimeException("Usuario no encontrado"));

		HistorialCorreo historial = new HistorialCorreo();
		historial.setUsuario(usuario);
		historial.setGmailMessageId(dto.getGmailMessageId());
		historial.setAsunto(dto.getAsunto());
		historial.setRemitente(dto.getRemitente());
		historial.setEscuchado(true);
		historial.setFechaEscucha(LocalDateTime.now());

		historialCorreoRepository.save(historial);
		return toDTO(historial);
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