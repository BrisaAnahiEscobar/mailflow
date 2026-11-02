package com.mailflow.security;

import com.google.api.client.googleapis.auth.oauth2.GoogleIdToken;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdTokenVerifier;
import com.google.api.client.http.javanet.NetHttpTransport;
import com.google.api.client.json.gson.GsonFactory;
import com.mailflow.exception.TokenInvalidoException;
import java.io.IOException;
import java.security.GeneralSecurityException;
import java.util.List;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

@Component
public class GoogleTokenVerifier {

	private final GoogleIdTokenVerifier verifier;

	public GoogleTokenVerifier(@Value("${google.client-ids}") List<String> clientIds) {
		this.verifier = new GoogleIdTokenVerifier.Builder(
				new NetHttpTransport(), GsonFactory.getDefaultInstance())
				.setAudience(clientIds)
				.build();
	}

	public GoogleIdToken.Payload verificar(String idToken) {
		try {
			GoogleIdToken token = verifier.verify(idToken);
			if (token == null) {
				throw new TokenInvalidoException("ID token de Google inválido o expirado");
			}
			GoogleIdToken.Payload payload = token.getPayload();
			if (!Boolean.TRUE.equals(payload.getEmailVerified())) {
				throw new TokenInvalidoException("El email de la cuenta de Google no está verificado");
			}
			return payload;
		} catch (GeneralSecurityException | IOException e) {
			throw new TokenInvalidoException("No se pudo verificar el token de Google", e);
		}
	}
}