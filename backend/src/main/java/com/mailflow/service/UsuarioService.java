package com.mailflow.service;

import com.mailflow.dto.AuthRequestDTO;
import com.mailflow.model.Preferencias;
import com.mailflow.model.Usuario;
import com.mailflow.repository.UsuarioRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class UsuarioService {

	private final UsuarioRepository usuarioRepository;
	private final JwtService jwtService;

	public AuthRequestDTO registrarOLoguear(String googleSub, String email) {
		Usuario usuario = usuarioRepository.findByGoogleSub(googleSub)
				.orElseGet(() -> crearUsuario(googleSub, email));

		String token = jwtService.generarToken(usuario.getEmail(), usuario.getId());
		return new AuthRequestDTO(token, usuario.getEmail(), usuario.getId());
	}

	private Usuario crearUsuario(String googleSub, String email) {
		Usuario nuevo = new Usuario();
		nuevo.setGoogleSub(googleSub);
		nuevo.setEmail(email);

		Preferencias preferencias = new Preferencias();
		preferencias.setUsuario(nuevo);
		nuevo.setPreferencias(preferencias);

		return usuarioRepository.save(nuevo);
	}
}
