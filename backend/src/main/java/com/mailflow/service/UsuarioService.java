package com.mailflow.service;

import com.google.api.client.googleapis.auth.oauth2.GoogleIdToken;
import com.mailflow.dto.AuthResponseDTO;
import com.mailflow.model.Preferencias;
import com.mailflow.model.Usuario;
import com.mailflow.repository.UsuarioRepository;
import com.mailflow.security.GoogleTokenVerifier;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class UsuarioService {

	private final UsuarioRepository usuarioRepository;
	private final JwtService jwtService;
	private final GoogleTokenVerifier googleTokenVerifier;

	@Transactional
	public AuthResponseDTO autenticarConGoogle(String idToken) {
		GoogleIdToken.Payload payload = googleTokenVerifier.verificar(idToken);
		String googleSub = payload.getSubject();
		String email = payload.getEmail();

		Usuario usuario = usuarioRepository.findByGoogleSub(googleSub)
				.orElseGet(() -> crearUsuario(googleSub, email));

		if (!email.equals(usuario.getEmail())) {
			usuario.setEmail(email);
		}

		String token = jwtService.generarToken(usuario.getEmail(), usuario.getId());
		return new AuthResponseDTO(token, usuario.getEmail(), usuario.getId());
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

